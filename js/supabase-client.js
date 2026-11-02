/**
 * BeMarket Supabase Client
 * Inspired by Avito.ru architecture
 */

// Import Supabase (CDN version for now)
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

// Configuration
const SUPABASE_URL = import.meta.env?.VITE_SUPABASE_URL || 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = import.meta.env?.VITE_SUPABASE_ANON_KEY || 'YOUR_ANON_KEY';

// Create Supabase client
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

/**
 * =====================
 * PRODUCTS API
 * =====================
 */

export const ProductsAPI = {
  /**
   * Get all active products with pagination
   */
  async getAll(page = 1, limit = 20, filters = {}) {
    const offset = (page - 1) * limit;

    let query = supabase
      .from('products')
      .select('*, categories(name, slug), users(full_name, avatar_url, rating)', { count: 'exact' })
      .eq('status', 'active')
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });

    // Apply filters
    if (filters.category_id) query = query.eq('category_id', filters.category_id);
    if (filters.location) query = query.eq('location_city', filters.location);
    if (filters.min_price) query = query.gte('price', filters.min_price);
    if (filters.max_price) query = query.lte('price', filters.max_price);
    if (filters.condition) query = query.eq('condition', filters.condition);

    const { data, error, count } = await query;

    return { data, error, total: count };
  },

  /**
   * Search products with full-text search
   */
  async search(searchQuery, filters = {}, sortBy = 'relevance', page = 1, limit = 20) {
    const { data, error } = await supabase
      .rpc('search_products', {
        search_query: searchQuery,
        category_filter: filters.category_id || null,
        location_filter: filters.location || null,
        min_price: filters.min_price || null,
        max_price: filters.max_price || null,
        condition_filter: filters.condition || null,
        sort_by: sortBy
      });

    // Pagination client-side (or modify SQL function)
    const offset = (page - 1) * limit;
    const paginatedData = data?.slice(offset, offset + limit);

    return { data: paginatedData, error, total: data?.length || 0 };
  },

  /**
   * Get single product by ID
   */
  async getById(id) {
    const { data, error } = await supabase
      .from('products')
      .select('*, categories(name, slug), users(full_name, avatar_url, rating, city)')
      .eq('id', id)
      .single();

    // Increment view count
    if (data) {
      await this.trackView(id);
    }

    return { data, error };
  },

  /**
   * Create new product
   */
  async create(productData) {
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return { data: null, error: { message: 'User not authenticated' } };
    }

    const { data, error } = await supabase
      .from('products')
      .insert([{ ...productData, seller_id: user.id, published_at: new Date().toISOString() }])
      .select()
      .single();

    return { data, error };
  },

  /**
   * Update product
   */
  async update(id, productData) {
    const { data, error } = await supabase
      .from('products')
      .update(productData)
      .eq('id', id)
      .select()
      .single();

    return { data, error };
  },

  /**
   * Delete product (soft delete - mark as archived)
   */
  async delete(id) {
    const { data, error } = await supabase
      .from('products')
      .update({ status: 'archived' })
      .eq('id', id);

    return { data, error };
  },

  /**
   * Track product view
   */
  async trackView(productId) {
    const { data: { user } } = await supabase.auth.getUser();

    const { error } = await supabase
      .from('product_views')
      .insert([{
        product_id: productId,
        user_id: user?.id || null,
        ip_address: null, // Would need server-side
        user_agent: navigator.userAgent
      }]);

    return { error };
  },

  /**
   * Get featured/best-seller products
   */
  async getFeatured(limit = 10) {
    const { data, error } = await supabase
      .from('products')
      .select('*, categories(name), users(full_name, avatar_url)')
      .eq('status', 'active')
      .eq('is_featured', true)
      .order('favorites_count', { ascending: false })
      .limit(limit);

    return { data, error };
  }
};

/**
 * =====================
 * FAVORITES API
 * =====================
 */

export const FavoritesAPI = {
  /**
   * Get user's favorites
   */
  async getAll() {
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) return { data: [], error: null };

    const { data, error } = await supabase
      .from('favorites')
      .select('*, products(*, categories(name), users(full_name, avatar_url))')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false });

    return { data, error };
  },

  /**
   * Add to favorites
   */
  async add(productId) {
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return { data: null, error: { message: 'User not authenticated' } };
    }

    const { data, error } = await supabase
      .from('favorites')
      .insert([{ user_id: user.id, product_id: productId }])
      .select()
      .single();

    return { data, error };
  },

  /**
   * Remove from favorites
   */
  async remove(productId) {
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) return { data: null, error: { message: 'User not authenticated' } };

    const { data, error } = await supabase
      .from('favorites')
      .delete()
      .eq('user_id', user.id)
      .eq('product_id', productId);

    return { data, error };
  },

  /**
   * Check if product is favorited
   */
  async isFavorited(productId) {
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) return { isFavorited: false };

    const { data, error } = await supabase
      .from('favorites')
      .select('id')
      .eq('user_id', user.id)
      .eq('product_id', productId)
      .single();

    return { isFavorited: !!data, error };
  }
};

/**
 * =====================
 * CATEGORIES API
 * =====================
 */

export const CategoriesAPI = {
  /**
   * Get all categories
   */
  async getAll() {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .is('parent_id', null)
      .order('order_index');

    return { data, error };
  },

  /**
   * Get subcategories
   */
  async getSubcategories(parentId) {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .eq('parent_id', parentId)
      .order('order_index');

    return { data, error };
  }
};

/**
 * =====================
 * AUTH API
 * =====================
 */

export const AuthAPI = {
  /**
   * Sign up with email
   */
  async signUp(email, password, metadata = {}) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: metadata
      }
    });

    return { data, error };
  },

  /**
   * Sign in with email
   */
  async signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    });

    return { data, error };
  },

  /**
   * Sign out
   */
  async signOut() {
    const { error } = await supabase.auth.signOut();
    return { error };
  },

  /**
   * Get current user
   */
  async getUser() {
    const { data: { user }, error } = await supabase.auth.getUser();
    return { user, error };
  },

  /**
   * Update user profile
   */
  async updateProfile(userId, profileData) {
    const { data, error } = await supabase
      .from('users')
      .update(profileData)
      .eq('id', userId)
      .select()
      .single();

    return { data, error };
  }
};

/**
 * =====================
 * STORAGE API
 * =====================
 */

export const StorageAPI = {
  /**
   * Upload image
   */
  async uploadImage(file, bucket = 'products') {
    const fileExt = file.name.split('.').pop();
    const fileName = `${Math.random().toString(36).substring(2)}_${Date.now()}.${fileExt}`;
    const filePath = `${bucket}/${fileName}`;

    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(filePath, file);

    if (error) return { data: null, error };

    // Get public URL
    const { data: { publicUrl } } = supabase.storage
      .from(bucket)
      .getPublicUrl(filePath);

    return { data: { path: filePath, url: publicUrl }, error: null };
  },

  /**
   * Delete image
   */
  async deleteImage(filePath, bucket = 'products') {
    const { data, error } = await supabase.storage
      .from(bucket)
      .remove([filePath]);

    return { data, error };
  }
};

/**
 * =====================
 * REALTIME SUBSCRIPTIONS
 * =====================
 */

export const RealtimeAPI = {
  /**
   * Subscribe to new products in category
   */
  subscribeToCategory(categoryId, callback) {
    return supabase
      .channel(`category:${categoryId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'products',
          filter: `category_id=eq.${categoryId}`
        },
        callback
      )
      .subscribe();
  },

  /**
   * Subscribe to product updates
   */
  subscribeToProduct(productId, callback) {
    return supabase
      .channel(`product:${productId}`)
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'products',
          filter: `id=eq.${productId}`
        },
        callback
      )
      .subscribe();
  }
};

// Export default supabase client
export default supabase;
