class Product {
  final String id;
  final String name;
  final String category;
  final String gender;
  final String brand;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> images;
  final List<String> colors;
  final List<String> sizes;
  final bool isNew;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.gender = 'Unisex',
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.images,
    required this.colors,
    required this.sizes,
    this.isNew = false,
  });

  double? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price)
      return null;
    return ((originalPrice! - price) /
        originalPrice! *
        100);
  }
}

class Category {
  final String name;
  final String imageUrl;

  Category(this.name, this.imageUrl);
}

final List<Category> mockCategories = [
  Category(
    'Women',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAGJEUgAGYmsXvFlYNdlt9hs_KpMUPnmBk_C8Ghnwdb8yMFX-E4PP5H7IwlVolgU6R6qBI4TihUjFjBtZDLLDAQo4ztPYheQHt_ThdjyKkK_bt1gevvDzkCehEAldMVE79UgwifYOk7rzgwPd2siYIpXcvnj3ehKrFJMcPoRt1mJ8TDK4_5wTaW7n-pov0FmAEOLS9-2XOrLnwyLyZRKjtiZngR73l_SSlbWIVmDd8EtJde73Fv7IF9rBQknFSLxxH-rdqTV3uP4uw',
  ),
  Category(
    'Men',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA_A2tMKtOa44GCXYUP8dT1BZt2Q6BzsS6mdeJmOic1Uwm86Y6jQ9lZ8Dr6r6FWjNCLrH2bZoXo5V6Fd1st-k62xNebKlu6wuQiDy-C0QY5t0pDpJlnF2pATHtQDeiMmvU97tKLNB7oqhw7vwbnKMew1voaJbfwZEkDFwUXgm4__RIOCgt7Qh6dlY2vRQmSrLcHsU6qavAcSzltELDuwWDf8D570qc47M5KVWIWNq-fLKYJhwyrxcOz87G7dRVxi0glEmq4AEewtxQ',
  ),
  Category(
    'Accessories',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAyLHd6wq2mH2kHiZJcGSvEY7MUrd9vxV_kglmbUqAQ3D64JXbk5_uXvcO8KGmFfBHYg7lzbHEpZd6tHAtMkjnFnnxrBUB1EvCBrhvVRUz9ZrY5YpNzmT8nZtTtFZOwWH4N6Td0R6yx14DuPlb6eQ-s9UWR5EZztlmH8PUnv0llWFqNEpznjuI7GGAlUKmwP6LwJIpbcCI8Zbz5rtjGWa6L6JRF-yhW5oH7V1ehExUNEXEdSBwLgpqGuNWEJbK7w5k_Wl-Md3fo-wg',
  ),
  Category(
    'Shoes',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAV2cfwVntFhykYPVCC6wolr82TqKBYlvOrlGvwtngSvbZYwMNQ4jYajeHOS7evySrrhWvmbFv1TYplxNFuxarwKpDUqY04I7fxSsftjoSwGvDe3rXrPY53Ha_g_uR6mSGs-KPgrcC3mUutBc9DMmCXOmdJT-V-fGscXR4o7h37BPTLiwP6G1N48_ox1zLMcf1BosyQCTwtt12WJA7pejS6S7O5OioMwOjcwbsRV96SGDpSr54qAodroXGD9z_1HLU3s59-WeuQaWo',
  ),
];

final List<Product> mockProducts = [
  // WOMEN
  Product(
    id: 'p1',
    name: 'Silk Blouse',
    category: 'Women',
    gender: 'Women',
    brand: 'Zentro',
    price: 120.00,
    originalPrice: 150.00,
    rating: 4.8,
    reviewCount: 124,
    description:
        'Elegant silk blouse with a relaxed fit. Perfect for both office and evening wear.',
    images: [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
    ],
    colors: ['White', 'Black'],
    sizes: ['S', 'M', 'L'],
    isNew: true,
  ),
  Product(
    id: 'p2',
    name: 'Floral Midi Dress',
    category: 'Women',
    gender: 'Women',
    brand: 'Zentro',
    price: 180.00,
    rating: 4.9,
    reviewCount: 89,
    description:
        'A beautiful floral midi dress for summer days and special occasions.',
    images: [
      'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&q=80',
    ],
    colors: ['Floral', 'Red'],
    sizes: ['XS', 'S', 'M', 'L'],
  ),
  Product(
    id: 'p3',
    name: 'Cashmere Turtleneck',
    category: 'Women',
    gender: 'Women',
    brand: 'Zentro',
    price: 250.00,
    rating: 4.9,
    reviewCount: 45,
    description:
        'Luxurious 100% cashmere turtleneck sweater for the ultimate soft feel and timeless elegance.',
    images: [
      'https://images.unsplash.com/photo-1550639525-c97d455acf70?w=800&q=80',
    ],
    colors: ['Grey', 'Cream'],
    sizes: ['XS', 'S', 'M', 'L'],
  ),
  Product(
    id: 'p4',
    name: 'Pleated Midi Skirt',
    category: 'Women',
    gender: 'Women',
    brand: 'Zentro',
    price: 110.00,
    rating: 4.6,
    reviewCount: 52,
    description:
        'High-waisted pleated skirt that drapes elegantly.',
    images: [
      'https://m.media-amazon.com/images/I/61B9drN63+S._AC_SX569_.jpg',
    ],
    colors: ['Navy', 'Black'],
    sizes: ['XS', 'S', 'M'],
  ),
  Product(
    id: 'p5',
    name: 'Wool Blend Coat',
    category: 'Women',
    gender: 'Women',
    brand: 'Zentro',
    price: 345.00,
    originalPrice: 400.00,
    rating: 4.8,
    reviewCount: 112,
    description:
        'A premium wool blend coat tailored for a perfect winter fit.',
    images: [
      'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=800&q=80',
    ],
    colors: ['Camel', 'Grey'],
    sizes: ['S', 'M', 'L'],
    isNew: true,
  ),

  // MEN
  Product(
    id: 'p6',
    name: 'Camel Overcoat',
    category: 'Men',
    gender: 'Men',
    brand: 'Wool Blend',
    price: 345.00,
    originalPrice: 430.00,
    rating: 4.8,
    reviewCount: 124,
    description:
        'A premium minimalist wool overcoat in camel color. Featuring a classic tailored fit.',
    images: [
      'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&q=80',
    ],
    colors: ['Camel', 'Navy'],
    sizes: ['S', 'M', 'L', 'XL'],
  ),
  Product(
    id: 'p7',
    name: 'Oxford Shirt',
    category: 'Men',
    gender: 'Men',
    brand: 'Pure Cotton',
    price: 120.00,
    rating: 4.6,
    reviewCount: 210,
    description:
        'A crisp, classic button-down shirt carefully crafted for a modern fit.',
    images: [
      'https://fittedshop.com/cdn/shop/files/6_a42aa6cd-958e-4cc9-ab5b-97096d8408d9.jpg?v=1784528241',
    ],
    colors: ['White', 'Light Blue'],
    sizes: ['S', 'M', 'L', 'XL'],
    isNew: true,
  ),
  Product(
    id: 'p8',
    name: 'Denim Jacket',
    category: 'Men',
    gender: 'Men',
    brand: 'Zentro',
    price: 150.00,
    originalPrice: 180.00,
    rating: 4.7,
    reviewCount: 88,
    description:
        'Classic denim jacket tailored for a modern fit. Features premium hardware.',
    images: [
      'https://discountstore.pk/cdn/shop/files/C24MDNMFSJKT401BLUEMEDIUM-C24MDNMFSJKT401-MXWIN24280824_01-2100.webp?v=1731749405',
    ],
    colors: ['Blue', 'Black'],
    sizes: ['S', 'M', 'L'],
  ),
  Product(
    id: 'p9',
    name: 'Chino Pants',
    category: 'Men',
    gender: 'Men',
    brand: 'Pure Cotton',
    price: 90.00,
    rating: 4.5,
    reviewCount: 156,
    description:
        'Comfortable and durable chino pants for everyday wear.',
    images: [
      'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&q=80',
    ],
    colors: ['Khaki', 'Navy'],
    sizes: ['30', '32', '34', '36'],
  ),
  Product(
    id: 'p10',
    name: 'Cashmere Crewneck',
    category: 'Men',
    gender: 'Men',
    brand: 'Zentro',
    price: 220.00,
    rating: 4.9,
    reviewCount: 45,
    description:
        'Extremely soft crewneck sweater made from premium cashmere.',
    images: [
      'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=800&q=80',
    ],
    colors: ['Grey', 'Black'],
    sizes: ['M', 'L', 'XL'],
    isNew: true,
  ),

  // ACCESSORIES
  Product(
    id: 'p11',
    name: 'Structured Tote',
    category: 'Accessories',
    gender: 'Women',
    brand: 'Italian Leather',
    price: 280.00,
    rating: 4.9,
    reviewCount: 89,
    description:
        'A sleek leather structured tote bag with subtle silver hardware.',
    images: [
      'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?w=800&q=80',
    ],
    colors: ['Black', 'Tan'],
    sizes: ['One Size'],
  ),
  Product(
    id: 'p12',
    name: 'Classic Watch',
    category: 'Accessories',
    gender: 'Men',
    brand: 'Zentro',
    price: 185.00,
    originalPrice: 220.00,
    rating: 4.5,
    reviewCount: 66,
    description:
        'A minimalist watch featuring a clean dial and a premium leather strap.',
    images: [
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
    ],
    colors: ['Silver', 'Gold'],
    sizes: ['One Size'],
  ),
  Product(
    id: 'p13',
    name: 'Cat-Eye Sunglasses',
    category: 'Accessories',
    gender: 'Women',
    brand: 'Zentro',
    price: 135.00,
    rating: 4.9,
    reviewCount: 154,
    description:
        'Sleek oversized sunglasses with UV protection and durable acetate frames.',
    images: [
      'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=800&q=80',
    ],
    colors: ['Black', 'Tortoise'],
    sizes: ['One Size'],
    isNew: true,
  ),
  Product(
    id: 'p14',
    name: 'Silk Scarf',
    category: 'Accessories',
    gender: 'Women',
    brand: 'Pure Silk',
    price: 85.00,
    rating: 4.8,
    reviewCount: 112,
    description:
        'A beautifully printed 100% silk scarf, versatile enough to wear around the neck.',
    images: [
      'https://www.suzainhijabs.pk/wp-content/uploads/2021/09/crinkle-silk-scarf-peach.jpg',
    ],
    colors: ['Pattern 1', 'Pattern 2'],
    sizes: ['One Size'],
  ),
  Product(
    id: 'p15',
    name: 'Leather Messenger Bag',
    category: 'Accessories',
    gender: 'Men',
    brand: 'Italian Leather',
    price: 260.00,
    rating: 4.7,
    reviewCount: 92,
    description:
        'A premium leather messenger bag perfect for commuting.',
    images: [
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&q=80',
    ],
    colors: ['Brown', 'Black'],
    sizes: ['One Size'],
  ),

  // SHOES
  Product(
    id: 'p16',
    name: 'Minimalist Sneaker',
    category: 'Shoes',
    gender: 'Unisex',
    brand: 'Leather & Suede',
    price: 195.00,
    rating: 4.7,
    reviewCount: 342,
    description:
        'A pair of contemporary, minimalist white sneakers.',
    images: [
      'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=800&q=80',
    ],
    colors: ['White', 'Off-White'],
    sizes: ['8', '9', '10', '11', '12'],
    isNew: true,
  ),
  Product(
    id: 'p17',
    name: 'Leather Loafers',
    category: 'Shoes',
    gender: 'Men',
    brand: 'Italian Leather',
    price: 215.00,
    rating: 4.4,
    reviewCount: 38,
    description:
        'Handcrafted leather loafers offering both exceptional comfort and a sleek silhouette.',
    images: [
      'https://sayaz.pk/cdn/shop/files/Article8Image2_1.jpg?v=1718014419&width=3840',
    ],
    colors: ['Brown', 'Black'],
    sizes: ['8', '9', '10', '11'],
  ),
  Product(
    id: 'p18',
    name: 'Chukka Boots',
    category: 'Shoes',
    gender: 'Men',
    brand: 'Leather & Suede',
    price: 165.00,
    originalPrice: 190.00,
    rating: 4.5,
    reviewCount: 99,
    description:
        'Versatile suede chukka boots designed for both casual outings and semi-formal events.',
    images: [
      'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&q=80',
    ],
    colors: ['Tan', 'Brown'],
    sizes: ['8', '9', '10', '11', '12'],
  ),
  Product(
    id: 'p19',
    name: 'Stiletto Heels',
    category: 'Shoes',
    gender: 'Women',
    brand: 'Italian Leather',
    price: 245.00,
    rating: 4.9,
    reviewCount: 156,
    description:
        'Classic stiletto heels made from premium leather.',
    images: [
      'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80',
    ],
    colors: ['Black', 'Nude'],
    sizes: ['6', '7', '8', '9'],
    isNew: true,
  ),
  Product(
    id: 'p20',
    name: 'Ankle Boots',
    category: 'Shoes',
    gender: 'Women',
    brand: 'Leather & Suede',
    price: 195.00,
    rating: 4.7,
    reviewCount: 84,
    description:
        'Comfortable and stylish ankle boots for every season.',
    images: [
      'https://images.unsplash.com/photo-1520639888713-7851133b1ed0?w=800&q=80',
    ],
    colors: ['Black', 'Brown'],
    sizes: ['6', '7', '8', '9'],
  ),
];
