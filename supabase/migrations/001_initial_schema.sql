-- BeMarket Database Schema
-- Inspired by Avito.ru marketplace structure

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===================
-- 1. USERS TABLE
-- ===================
CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    phone TEXT,
    avatar_url TEXT,
    city TEXT DEFAULT 'Cotonou',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    is_verified BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_sales INT DEFAULT 0
);

-- RLS Policies for users
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile"
    ON public.users FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
    ON public.users FOR UPDATE
    USING (auth.uid() = id);

-- ===================
-- 2. CATEGORIES TABLE
-- ===================
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    parent_id UUID REFERENCES public.categories(id) ON DELETE CASCADE,
    icon TEXT,
    order_index INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Insert default categories
INSERT INTO public.categories (name, slug, icon, order_index) VALUES
('Électronique', 'electronique', 'fa-microchip', 1),
('Mode & Vêtements', 'mode-vetements', 'fa-shirt', 2),
('Maison & Jardin', 'maison-jardin', 'fa-house', 3),
('Véhicules', 'vehicules', 'fa-car', 4),
('Immobilier', 'immobilier', 'fa-building', 5),
('Services', 'services', 'fa-wrench', 6),
('Emploi', 'emploi', 'fa-briefcase', 7),
('Loisirs', 'loisirs', 'fa-gamepad', 8);

-- ===================
-- 3. PRODUCTS TABLE
-- ===================
CREATE TABLE public.products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    price DECIMAL(12,2) NOT NULL,
    currency TEXT DEFAULT 'XOF',
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    images TEXT[] DEFAULT '{}',
    seller_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    location_city TEXT DEFAULT 'Cotonou',
    condition TEXT CHECK (condition IN ('new', 'like_new', 'used', 'refurbished')) DEFAULT 'new',
    status TEXT CHECK (status IN ('active', 'sold', 'archived', 'pending')) DEFAULT 'active',
    views_count INT DEFAULT 0,
    favorites_count INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    is_urgent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    published_at TIMESTAMP WITH TIME ZONE,

    -- Search optimization
    search_vector TSVECTOR GENERATED ALWAYS AS (
        setweight(to_tsvector('french', COALESCE(title, '')), 'A') ||
        setweight(to_tsvector('french', COALESCE(description, '')), 'B')
    ) STORED
);

-- Indexes for performance
CREATE INDEX idx_products_search ON public.products USING GIN(search_vector);
CREATE INDEX idx_products_category ON public.products(category_id);
CREATE INDEX idx_products_seller ON public.products(seller_id);
CREATE INDEX idx_products_status ON public.products(status);
CREATE INDEX idx_products_created ON public.products(created_at DESC);
CREATE INDEX idx_products_price ON public.products(price);
CREATE INDEX idx_products_location ON public.products(location_city);

-- RLS Policies for products
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active products"
    ON public.products FOR SELECT
    USING (status = 'active');

CREATE POLICY "Sellers can manage their own products"
    ON public.products FOR ALL
    USING (auth.uid() = seller_id);

-- ===================
-- 4. FAVORITES TABLE
-- ===================
CREATE TABLE public.favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
    UNIQUE(user_id, product_id)
);

-- Index for favorites
CREATE INDEX idx_favorites_user ON public.favorites(user_id);
CREATE INDEX idx_favorites_product ON public.favorites(product_id);

-- RLS Policies for favorites
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own favorites"
    ON public.favorites FOR ALL
    USING (auth.uid() = user_id);

-- ===================
-- 5. SEARCH HISTORY TABLE
-- ===================
CREATE TABLE public.search_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    query TEXT NOT NULL,
    filters JSONB DEFAULT '{}',
    results_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Index for search history
CREATE INDEX idx_search_history_user ON public.search_history(user_id);
CREATE INDEX idx_search_history_created ON public.search_history(created_at DESC);

-- RLS Policies for search history
ALTER TABLE public.search_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own search history"
    ON public.search_history FOR ALL
    USING (auth.uid() = user_id OR user_id IS NULL);

-- ===================
-- 6. VIEWS TABLE (Analytics)
-- ===================
CREATE TABLE public.product_views (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Index for views
CREATE INDEX idx_views_product ON public.product_views(product_id);
CREATE INDEX idx_views_created ON public.product_views(created_at DESC);

-- ===================
-- 7. MESSAGES TABLE (Chat)
-- ===================
CREATE TABLE public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
    sender_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    receiver_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Index for messages
CREATE INDEX idx_messages_sender ON public.messages(sender_id);
CREATE INDEX idx_messages_receiver ON public.messages(receiver_id);
CREATE INDEX idx_messages_product ON public.messages(product_id);
CREATE INDEX idx_messages_created ON public.messages(created_at DESC);

-- RLS Policies for messages
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own messages"
    ON public.messages FOR SELECT
    USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can send messages"
    ON public.messages FOR INSERT
    WITH CHECK (auth.uid() = sender_id);

-- ===================
-- 8. TRIGGERS
-- ===================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc', NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Increment product views count
CREATE OR REPLACE FUNCTION increment_product_views()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.products
    SET views_count = views_count + 1
    WHERE id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_increment_product_views
    AFTER INSERT ON public.product_views
    FOR EACH ROW
    EXECUTE FUNCTION increment_product_views();

-- Update favorites count
CREATE OR REPLACE FUNCTION update_favorites_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.products
        SET favorites_count = favorites_count + 1
        WHERE id = NEW.product_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.products
        SET favorites_count = favorites_count - 1
        WHERE id = OLD.product_id;
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_favorites_count
    AFTER INSERT OR DELETE ON public.favorites
    FOR EACH ROW
    EXECUTE FUNCTION update_favorites_count();

-- ===================
-- 9. FUNCTIONS
-- ===================

-- Search products function
CREATE OR REPLACE FUNCTION search_products(
    search_query TEXT,
    category_filter UUID DEFAULT NULL,
    location_filter TEXT DEFAULT NULL,
    min_price DECIMAL DEFAULT NULL,
    max_price DECIMAL DEFAULT NULL,
    condition_filter TEXT DEFAULT NULL,
    sort_by TEXT DEFAULT 'relevance'
)
RETURNS TABLE (
    id UUID,
    title TEXT,
    description TEXT,
    price DECIMAL,
    images TEXT[],
    location_city TEXT,
    condition TEXT,
    views_count INT,
    favorites_count INT,
    created_at TIMESTAMP WITH TIME ZONE,
    rank REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.title,
        p.description,
        p.price,
        p.images,
        p.location_city,
        p.condition,
        p.views_count,
        p.favorites_count,
        p.created_at,
        ts_rank(p.search_vector, plainto_tsquery('french', search_query)) AS rank
    FROM public.products p
    WHERE p.status = 'active'
        AND (category_filter IS NULL OR p.category_id = category_filter)
        AND (location_filter IS NULL OR p.location_city = location_filter)
        AND (min_price IS NULL OR p.price >= min_price)
        AND (max_price IS NULL OR p.price <= max_price)
        AND (condition_filter IS NULL OR p.condition = condition_filter)
        AND (search_query IS NULL OR p.search_vector @@ plainto_tsquery('french', search_query))
    ORDER BY
        CASE WHEN sort_by = 'relevance' THEN ts_rank(p.search_vector, plainto_tsquery('french', search_query)) END DESC,
        CASE WHEN sort_by = 'recent' THEN p.created_at END DESC,
        CASE WHEN sort_by = 'price_asc' THEN p.price END ASC,
        CASE WHEN sort_by = 'price_desc' THEN p.price END DESC,
        CASE WHEN sort_by = 'popular' THEN p.views_count END DESC;
END;
$$ LANGUAGE plpgsql STABLE;

-- Grant permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;
