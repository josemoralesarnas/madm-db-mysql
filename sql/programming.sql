-- ============================================================
-- MADM — Madrid Digital Music Platform
-- Programming (procedures, functions, triggers and events)
-- ============================================================
USE madm;
-- ============================================================
-- PROCEDURES
-- ============================================================
DELIMITER //

-- register_play
-- Centralizes the action of registering a song play.
-- The app can call this procedure instead of writing the insert manually.
CREATE PROCEDURE register_play ( 
    IN p_account_id INT,
    IN p_song_id INT
)
BEGIN
    INSERT INTO Play (account_id, song_id)
    VALUES (p_account_id, p_song_id);
END//

-- review_artist_request
-- Administrators can approve or reject artist requests through a controlled procedure
CREATE PROCEDURE review_artist_request (
    IN p_request_id INT,
    IN p_admin_id INT,
    IN p_status ENUM('approved', 'rejected'),
    IN p_notes TEXT
)
BEGIN
    UPDATE ArtistRequest
    SET status = p_status,
        admin_id = p_admin_id,
        notes = p_notes,
        review_date = CURRENT_DATE
    WHERE request_id = p_request_id
      AND status = 'pending';
END//

-- ============================================================
-- FUNCTIONS
-- ============================================================

-- is_premium_user
-- Allows the database to check if a user has premium access.
CREATE FUNCTION is_premium_user (p_account_id INT)
RETURNS BOOLEAN READS SQL DATA
BEGIN
    DECLARE v_is_premium BOOLEAN DEFAULT FALSE;

    SELECT COUNT(*) > 0
    INTO v_is_premium
    FROM Subscription s
    JOIN Plan p ON s.plan_id = p.plan_id
    WHERE s.account_id = p_account_id
      AND s.status = 'active'
      AND p.name IN ('Premium', 'Family')
      AND (s.end_date IS NULL OR s.end_date >= CURRENT_DATE);

    RETURN v_is_premium;
END//

-- ============================================================
-- TRIGGERS
-- ============================================================

-- playlist_before_insert
-- Prevents free users from creating playlists.
CREATE TRIGGER playlist_before_insert
BEFORE INSERT ON Playlist
FOR EACH ROW
BEGIN
    IF is_premium_user(NEW.account_id) = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only premium users can create playlists';
    END IF;
END//

-- play_after_insert
-- Keeps the song counter updated automatically.
CREATE TRIGGER play_after_insert
AFTER INSERT ON Play
FOR EACH ROW
BEGIN
    UPDATE Song
    SET play_count = play_count + 1
    WHERE song_id = NEW.song_id;
END//

-- order_item_after_insert
-- Reduces inventory stock after a sale.
CREATE TRIGGER order_item_after_insert
AFTER INSERT ON Order_Item
FOR EACH ROW
BEGIN
    UPDATE Inventory
    SET stock = stock - NEW.quantity
    WHERE variant_id = NEW.variant_id;
END//

-- artist_request_after_update
-- Marks an artist as verified when their request is approved.
CREATE TRIGGER artist_request_after_update
AFTER UPDATE ON ArtistRequest
FOR EACH ROW
BEGIN
    IF NEW.status = 'approved' AND OLD.status <> 'approved' THEN
        UPDATE Artist
        SET verified = TRUE
        WHERE account_id = NEW.account_id;
    END IF;
END//

-- ============================================================
-- EVENTS
-- ============================================================

-- expire_subscriptions
-- Expires old active subscriptions once per day.
CREATE EVENT IF NOT EXISTS expire_subscriptions
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE Subscription
    SET status = 'expired'
    WHERE status = 'active'
      AND end_date IS NOT NULL
      AND end_date < CURRENT_DATE;
END//

DELIMITER ;
