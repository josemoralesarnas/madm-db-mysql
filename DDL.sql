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