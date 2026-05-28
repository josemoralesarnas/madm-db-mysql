# Analysis

## 1. Chosen organization

**MADM** is a digital music streaming platform built exclusively around artists based in Madrid. Its mission is to give visibility to local talent by creating a curated, closed ecosystem where every piece of content originates from the city. Beyond streaming, MADM connects listeners directly with artists through a built-in store where artists can sell merchandise, physical records, and concert tickets, turning passive listeners into active supporters of the Madrid music scene.

---

## 2. Problem or Need It Solves

Emerging artists in Madrid face a structural visibility problem on global streaming platforms, where algorithmic competition makes it nearly impossible to reach a relevant audience without an already established following.

MADM addresses this by removing that competition entirely. On this platform, the catalog is exclusively Madrid-based, which means every listener is already a potential fan, and every search or recommendation stays within the local scene. Artists do not compete against global acts for attention; they compete on the quality of their music alone.

At the same time, MADM recognises that music alone is not enough to sustain an independent artist. The integrated store allows artists to monetise their identity beyond streams, offering physical products and live experiences directly to their audience without relying on third-party services.

---

## **3. Information It Needs to Manage**

<aside>

### Users and Access

Listener accounts (free and premium), subscriptions, plans, and payments.

</aside>

<aside>

### Music catalog

Artists, albums, songs, genres, collaborations, and release dates.

</aside>

<aside>

### Administration

Validate artists.

</aside>

<aside>

### User Interaction

Play history, star ratings on songs, artist follows, playlist creation and following (premium only), album collections, and personalization preferences.

</aside>

<aside>

### Artist verification

Artist onboarding requests, review status, verification history, and review team management.

</aside>

<aside>

### Artist Store

Products offered by artists (merchandise, physical records, and concert tickets), product variants (sizes, formats, ticket categories), real-time inventory per variant, and order management.

</aside>

---

## 4. Main Processes

**1. Artist registration and verification**
An artist submits an onboarding request through the platform. An MADM administrator reviews the application and verifies Madrid residency. The request is then approved or rejected, with an assigned reviewer.

**2. Content publishing**
Once verified, the artist can upload songs and albums to the platform. All published content becomes immediately available in the catalog for every listener, regardless of their subscription plan.

**3. Music consumption**
Listeners browse and play songs from the catalog, give STARs to tracks, follow artists, and save albums to their personal collection. Every play is recorded individually, generating a full listening history per user.

**4. Subscription and payment management**
Users can upgrade to the premium plan at any time. The system manages the active subscription period, renewal dates, and associated payment records, allowing listeners to downgrade as needed.

**5. Playlist management**
Premium listeners can create their own playlists, add or remove songs, and make them available for other users to follow. Playlist ownership and follower relationships are tracked independently.

**6. Artist store and order management**
Artists can list products in their store, including merchandise, physical records, and concert tickets, each with defined variants and real inventory tracking. Listeners can place orders, which are recorded as individual order lines linked to specific product variants.

---

## **5. User Profiles**

<aside>

### **Free listener**

 Can browse the full catalog, play any song, follow artists, give STARs to tracks, and save albums to their personal collection. No subscription fee required.

</aside>

<aside>

### **Premium listener**

Includes everything available in the free tier, with the addition of playlist creation and management, the ability to follow other users' playlists, and access to personalization features. Requires an active paid subscription.

</aside>

<aside>

### Artist

Holds a separate account from any listener profile. Once verified by the MADM team, can upload songs and albums to the platform, manage their public profile and catalog, and operate their own store to sell merchandise, physical records, and concert tickets.

</aside>

<aside>

### **MADM Administrator**

Internal platform role responsible for reviewing artist onboarding requests, verifying Madrid residency. Manages the verification workflow and maintains the integrity of the platform's artist catalog.

</aside>

# E/R Diagram

![Diagrama diseñado con draw.io](attachment:b9ecfdff-c4ba-4429-8a40-319781c03308:Diagrama_conceptual_ER.drawio.svg)

Diagrama diseñado con draw.io

# Relational model

![Diagrama diseñado con draw.io](attachment:93fb6727-2ba6-4d91-afe5-e80ae3e39f40:Diagrama_conceptual_ER-Page-2.drawio_(1).svg)

Diagrama diseñado con draw.io

# MySQL implementation

## DDL

```sql
-- ============================================================
-- MADM — Madrid Digital Music Platform
-- DDL
-- ============================================================

DROP DATABASE IF EXISTS madm;
CREATE DATABASE IF NOT EXISTS madm;

USE madm;

-- ============================================================
-- ACCOUNTS
-- ============================================================

CREATE TABLE `Account` (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    registration_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_email
        CHECK (
            email REGEXP
            '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'
        )
);

CREATE TABLE `User` (
    account_id INT PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,

    CONSTRAINT fk_user_account
        FOREIGN KEY (account_id)
        REFERENCES `Account` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_username
        CHECK (
            username REGEXP
            '^[A-Za-z0-9](?:[A-Za-z0-9._]{0,28}[A-Za-z0-9])?$'
        )
);

CREATE TABLE Artist (
    account_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    profile_picture VARCHAR(255),

    CONSTRAINT fk_artist_account
        FOREIGN KEY (account_id)
        REFERENCES `Account` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- ADMINISTRATION
-- ============================================================

CREATE TABLE `Admin` (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('superadmin', 'moderator', 'support') NOT NULL,

    CONSTRAINT chk_email_admin
        CHECK (
            email REGEXP
            '^[A-Za-z0-9._%+-]+@madm\\.com$'
        )
);

-- ============================================================
-- MUSIC CATALOG
-- ============================================================

CREATE TABLE Genre (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Album (
    album_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    release_date DATE,
    cover_url VARCHAR(255),
    type ENUM('LP', 'EP', 'Single') NOT NULL,
    account_id INT NOT NULL,

    CONSTRAINT fk_album_artist
        FOREIGN KEY (account_id)
        REFERENCES Artist (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Song (
    song_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    duration INT NOT NULL CHECK (duration BETWEEN 1 AND 3600),
    release_date DATE,
    play_count INT NOT NULL DEFAULT 0,
    genre_id INT,

    CONSTRAINT fk_song_genre
        FOREIGN KEY (genre_id)
        REFERENCES Genre (genre_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ============================================================
-- SUBSCRIPTIONS & PLANS
-- ============================================================

CREATE TABLE Plan (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(6,2) NOT NULL,
    features TEXT
);

CREATE TABLE Subscription (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('active', 'cancelled', 'expired') NOT NULL DEFAULT 'active',
    payment_method VARCHAR(50),
    account_id INT NOT NULL,
    plan_id INT NOT NULL,

    CONSTRAINT fk_subscription_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_subscription_plan
        FOREIGN KEY (plan_id)
        REFERENCES Plan (plan_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_subscription_dates
        CHECK (
            end_date IS NULL
            OR end_date >= start_date
        )
);

-- ============================================================
-- PLAYLISTS
-- ============================================================

CREATE TABLE Playlist (
    playlist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    account_id INT NOT NULL,

    CONSTRAINT fk_playlist_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- ARTIST VERIFICATION
-- ============================================================

CREATE TABLE ArtistRequest (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    submission_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    notes TEXT,
    review_date DATE,
    account_id INT NOT NULL,
    admin_id INT,

    CONSTRAINT fk_artistrequest_artist
        FOREIGN KEY (account_id)
        REFERENCES Artist (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_artistrequest_admin
        FOREIGN KEY (admin_id)
        REFERENCES `Admin` (admin_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_artistrequest_review
        CHECK (
            review_date IS NULL
            OR review_date >= submission_date
        )
);

-- ============================================================
-- ARTIST STORE
-- ============================================================

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    type ENUM('merchandise', 'vinyl', 'ticket') NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    account_id INT NOT NULL,

    CONSTRAINT fk_product_artist
        FOREIGN KEY (account_id)
        REFERENCES Artist (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Product_Variant (
    variant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    product_id INT NOT NULL,

    CONSTRAINT fk_product_variant_product
        FOREIGN KEY (product_id)
        REFERENCES Product (product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    variant_id INT NOT NULL UNIQUE,

    CONSTRAINT fk_inventory_variant
        FOREIGN KEY (variant_id)
        REFERENCES Product_Variant (variant_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    account_id INT NOT NULL,

    CONSTRAINT fk_order_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE Order_Item (
    order_id INT,
    variant_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(8,2) NOT NULL CHECK (unit_price >= 0),

    PRIMARY KEY (order_id, variant_id),

    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id)
        REFERENCES `Order` (order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_order_item_variant
        FOREIGN KEY (variant_id)
        REFERENCES Product_Variant (variant_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================================
-- N:M RELATIONSHIP TABLES
-- ============================================================
CREATE TABLE Song_Album (
    song_id INT,
    album_id INT,
    position INT NOT NULL CHECK (position > 0),
    
    UNIQUE (album_id, position),

    PRIMARY KEY (song_id, album_id),

    CONSTRAINT fk_song_album_song
        FOREIGN KEY (song_id)
        REFERENCES Song (song_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_song_album_album
        FOREIGN KEY (album_id)
        REFERENCES Album (album_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Song_Artist (
    account_id INT,
    song_id INT,
    role VARCHAR(50) NOT NULL DEFAULT 'main',

    PRIMARY KEY (account_id, song_id),

    CONSTRAINT fk_song_artist_artist
        FOREIGN KEY (account_id)
        REFERENCES Artist (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_song_artist_song
        FOREIGN KEY (song_id)
        REFERENCES Song (song_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Playlist_Song (
    playlist_id INT,
    song_id INT,
    position INT NOT NULL CHECK (position > 0),
    
    UNIQUE(playlist_id, position),

    PRIMARY KEY (playlist_id, song_id),

    CONSTRAINT fk_playlist_song_playlist
        FOREIGN KEY (playlist_id)
        REFERENCES Playlist (playlist_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_playlist_song_song
        FOREIGN KEY (song_id)
        REFERENCES Song (song_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Star (
    account_id INT,
    song_id INT,

    PRIMARY KEY (account_id, song_id),

    CONSTRAINT fk_star_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_star_song
        FOREIGN KEY (song_id)
        REFERENCES Song (song_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Play (
    play_id INT AUTO_INCREMENT PRIMARY KEY,
    played_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_id INT NOT NULL,
    song_id INT NOT NULL,

    CONSTRAINT fk_play_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_play_song
        FOREIGN KEY (song_id)
        REFERENCES Song (song_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Collection (
    account_id INT,
    album_id INT,

    PRIMARY KEY (account_id, album_id),

    CONSTRAINT fk_collection_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_collection_album
        FOREIGN KEY (album_id)
        REFERENCES Album (album_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Follow_Artist (
    account_id INT,
    artist_id INT,
    follow_date DATE NOT NULL DEFAULT (CURRENT_DATE),

    PRIMARY KEY (account_id, artist_id),

    CONSTRAINT fk_follow_artist_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_follow_artist_artist
        FOREIGN KEY (artist_id)
        REFERENCES Artist (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Follow_Playlist (
    account_id INT,
    playlist_id INT,

    PRIMARY KEY (account_id, playlist_id),

    CONSTRAINT fk_follow_playlist_user
        FOREIGN KEY (account_id)
        REFERENCES `User` (account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_follow_playlist_playlist
        FOREIGN KEY (playlist_id)
        REFERENCES Playlist (playlist_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- END
-- ============================================================
```

## DML

```sql
-- ============================================================
-- MADM — Madrid Digital Music Platform
-- DML
-- ============================================================

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
    '2025-01-01',
    '2025-12-31',
    'credit card',
    1,
    2
),
(
    '2025-01-01',
    '2025-12-31',
    'credit card',
    2,
    1
),
(
    '2025-02-15',
    '2026-02-15',
    'paypal',
    4,
    1
),
(
    '2025-03-01',
    '2026-03-01',
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
```

# Business-oriented SQL queries
