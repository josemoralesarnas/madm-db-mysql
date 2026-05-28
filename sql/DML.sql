-- ============================================================
-- MADM — Madrid Digital Music Platform
-- DML
-- ============================================================
USE madm;
-- ============================================================
-- ACCOUNTS
-- ============================================================

INSERT INTO `Account` (email, password)
VALUES
    ('pepe@gmail.com', 'Hola1234'),
    ('josefa@gmail.com', 'Adios1234'),
    ('madmayden@gmail.com', 'Music1234'),
    ('lucia.music@gmail.com', 'Lucia1234'),
    ('carlosbeats@gmail.com', 'Carlos1234'),
    ('sara.lopez@gmail.com', 'Sara1234'),
    ('daniwaves@gmail.com', 'Dani1234'),
    ('neonpulse@gmail.com', 'Neon1234');

-- ============================================================
-- USERS
-- ============================================================

INSERT INTO `User` (account_id, username)
VALUES
    (1, 'pepitogrillo'),
    (2, 'josefa03'),
    (4, 'lucia_music'),
    (5, 'carlosbeats'),
    (6, 'sara_vibes'),
    (7, 'daniwaves');

-- ============================================================
-- ARTISTS
-- ============================================================

INSERT INTO Artist (
    account_id,
    name,
    bio,
    verified,
    profile_picture
)
VALUES
(
    3,
    'Mad Mayden',
    'Artista de Madrid desde 2018',
    TRUE,
    'https://pbs.twimg.com/profile_images/2046623117141848067/b_RwEJRz_400x400.jpg'
),
(
    7,
    'Dani Waves',
    'Productor indie y synthwave',
    FALSE,
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e'
),
(
    8,
    'Neon Pulse',
    'Banda electrónica alternativa',
    TRUE,
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
);

-- ============================================================
-- ADMINS
-- ============================================================

INSERT INTO `Admin` (name, email, role)
VALUES
(
    'María Linares',
    'admin@madm.com',
    'moderator'
),
(
    'Sergio Torres',
    'support@madm.com',
    'support'
);

-- ============================================================
-- GENRES
-- ============================================================

INSERT INTO Genre (name)
VALUES
    ('Pop'),
    ('Rock'),
    ('Indie'),
    ('Electronic'),
    ('Synthwave');

-- ============================================================
-- ALBUMS
-- ============================================================

INSERT INTO Album (
    title,
    release_date,
    cover_url,
    type,
    account_id
)
VALUES
(
    'Yokai',
    '2024-08-09',
    'https://cdn-images.dzcdn.net/images/cover/40265eddc91cc8c61d0448e161fd2c44/1900x1900-000000-80-0-0.jpg',
    'LP',
    3
),
(
    'No Te Voy a Olvidar',
    '2025-05-22',
    'https://pbs.twimg.com/profile_images/2046623117141848067/b_RwEJRz_400x400.jpg',
    'Single',
    3
),
(
    'LILITH',
    '2023-12-15',
    'https://cdn-images.dzcdn.net/images/cover/662837a2ee24b41c19670d9caeda7694/1900x1900-000000-80-0-0.jpg',
    'EP',
    3
),
(
    'Night Drive',
    '2024-11-10',
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f',
    'EP',
    7
),
(
    'Electric Dreams',
    '2025-02-01',
    'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
    'LP',
    8
);

-- ============================================================
-- SONGS
-- ============================================================

INSERT INTO Song (
    title,
    duration,
    release_date,
    genre_id
)
VALUES
(
    'No Te Voy a Olvidar',
    212,
    '2025-05-22',
    1
),
(
    'LILITH',
    182,
    '2023-12-15',
    1
),
(
    'LOSE OUR SHAME',
    174,
    '2024-08-09',
    3
),
(
    'Midnight Lights',
    205,
    '2024-11-10',
    5
),
(
    'Neon Skyline',
    198,
    '2025-02-01',
    4
),
(
    'Digital Heartbeat',
    220,
    '2025-02-01',
    4
);

-- ============================================================
-- PLANS
-- ============================================================

INSERT INTO Plan (
    name,
    price,
    features
)
VALUES
(
    'Premium',
    4.99,
    'Playlist creation, offline mode and no ads'
),
(
    'Free',
    0.00,
    'Basic access with ads'
),
(
    'Family',
    9.99,
    'Up to 5 users with premium access'
);

-- ============================================================
-- SUBSCRIPTIONS
-- ============================================================

INSERT INTO Subscription (
    start_date,
    end_date,
    payment_method,
    account_id,
    plan_id
)
VALUES
(
    '2026-01-01',
    '2026-12-31',
    'credit card',
    1,
    2
),
(
    '2026-01-01',
    '2026-12-31',
    'credit card',
    2,
    1
),
(
    '2025-02-15',
    '2026-12-31',
    'paypal',
    4,
    1
),
(
    '2025-03-01',
    '2026-12-31',
    'credit card',
    5,
    3
);

-- ============================================================
-- PLAYLISTS
-- ============================================================

INSERT INTO Playlist (
    name,
    description,
    account_id
)
VALUES
(
    'Workout Mix',
    'Music for training',
    2
),
(
    'Chill Mix',
    'Relaxing songs for late nights',
    2
),
(
    'Synthwave Nights',
    'Retro electronic vibes',
    4
),
(
    'Focus Session',
    'Music for studying and coding',
    5
);

-- ============================================================
-- ARTIST REQUESTS
-- ============================================================

INSERT INTO ArtistRequest (
    submission_date,
    status,
    notes,
    review_date,
    account_id,
    admin_id
)
VALUES
(
    '2025-05-01',
    'approved',
    'Verification confirmed',
    '2025-05-02',
    3,
    1
),
(
    '2025-04-12',
    'pending',
    'Waiting for identity confirmation',
    NULL,
    7,
    2
);

-- ============================================================
-- PRODUCTS & VARIANTS
-- ============================================================

INSERT INTO Product (
    name,
    description,
    type,
    price,
    account_id
)
VALUES
(
    'Tour T-Shirt',
    'Official merchandise',
    'merchandise',
    24.99,
    3
),
(
    'Yokai Vinyl',
    'Collector vinyl edition',
    'vinyl',
    35.99,
    3
),
(
    'Night Drive Poster',
    'Limited edition poster',
    'merchandise',
    14.99,
    7
);

INSERT INTO Product_Variant (name, product_id)
VALUES
    ('Size M', 1),
    ('Size L', 1),
    ('First Edition', 2),
    ('Signed Version', 2),
    ('A2 Size', 3);

INSERT INTO Inventory (stock, variant_id)
VALUES
    (25, 1),
    (20, 2),
    (50, 3),
    (10, 4),
    (30, 5);

-- ============================================================
-- ORDERS
-- ============================================================

INSERT INTO `Order` (total_amount, account_id)
VALUES
    (60.98, 1),
    (14.99, 4),
    (35.99, 5);

INSERT INTO Order_Item (
    order_id,
    variant_id,
    quantity,
    unit_price
)
VALUES
(
    1,
    1,
    1,
    24.99
),
(
    1,
    3,
    1,
    35.99
),
(
    2,
    5,
    1,
    14.99
),
(
    3,
    4,
    1,
    35.99
);

-- ============================================================
-- SONG_ARTIST
-- ============================================================

INSERT INTO Song_Artist (account_id, song_id, role)
VALUES
    (3, 1, 'main'),
    (3, 2, 'main'),
    (3, 3, 'main'),
    (7, 4, 'main'),
    (8, 5, 'main'),
    (8, 6, 'main');

-- ============================================================
-- SONG_ALBUM
-- ============================================================

INSERT INTO Song_Album (
    song_id,
    album_id,
    position
)
VALUES
    (1, 2, 1),
    (2, 3, 1),
    (3, 1, 1),
    (2, 1, 2),
    (4, 4, 1),
    (5, 5, 1),
    (6, 5, 2);

-- ============================================================
-- PLAYLIST_SONG
-- ============================================================

INSERT INTO Playlist_Song (
    playlist_id,
    song_id,
    position
)
VALUES
    (1, 2, 1),
    (1, 3, 2),
    (2, 1, 1),
    (2, 4, 2),
    (3, 4, 1),
    (3, 5, 2),
    (4, 6, 1);

-- ============================================================
-- STARS
-- ============================================================

INSERT INTO Star (account_id, song_id)
VALUES
    (1, 1),
    (2, 2),
    (1, 3),
    (4, 4),
    (5, 5),
    (6, 6);

-- ============================================================
-- PLAYS
-- ============================================================

INSERT INTO Play (account_id, song_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (2, 1),
    (4, 5);

-- ============================================================
-- COLLECTIONS
-- ============================================================

INSERT INTO Collection (account_id, album_id)
VALUES
    (1, 1),
    (2, 1),
    (4, 5),
    (5, 4);

-- ============================================================
-- FOLLOW_ARTISTS
-- ============================================================

INSERT INTO Follow_Artist (account_id, artist_id)
VALUES
    (1, 3),
    (2, 3),
    (4, 7),
    (5, 8),
    (6, 3),
    (6, 8);

-- ============================================================
-- FOLLOW_PLAYLISTS
-- ============================================================

INSERT INTO Follow_Playlist (account_id, playlist_id)
VALUES
    (2, 1),
    (2, 2),
    (4, 3),
    (5, 4),
    (6, 2);

-- ============================================================
-- END
-- ============================================================
