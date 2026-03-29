CREATE DATABASE IF NOT EXISTS streaming_platform ;
USE streaming_platform;

# ---------------------------------- CREATE COMMANDS ---------------------------------- #

CREATE TABLE IF NOT EXISTS Subscription_Plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    duration INT NOT NULL,
    device_limit INT CHECK (device_limit > 0)
);


CREATE TABLE IF NOT EXISTS Advertisement (
    ad_id INT PRIMARY KEY,
    ad_name VARCHAR(255) NOT NULL,
    ad_duration INT CHECK (ad_duration > 0),
    category VARCHAR(100) NOT NULL,
    target_region VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Basic (
    plan_id INT,
    ad_id INT,
    PRIMARY KEY (plan_id, ad_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ad_id) REFERENCES Advertisement(ad_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Standard (
    plan_id INT PRIMARY KEY,
    offline_download BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Premium (
    plan_id INT PRIMARY KEY,
    spatial_audio_support BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS `User` (
    user_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    plan_id INT,
    country VARCHAR(100),
    date_of_birth DATE,
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id)  ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS AD_views (
    ad_view_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    ad_id INT,
    view_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ad_id) REFERENCES Advertisement(ad_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Other') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS `Profiles` (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    profile_name VARCHAR(100) NOT NULL,
    age_restriction VARCHAR(50),
    preferred_language VARCHAR(50),
    last_active_device VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Devices (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    device_type VARCHAR(50) NOT NULL,
    os VARCHAR(50),
    ip_address VARCHAR(45),  -- IPv4 or IPv6
    last_login TIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Customer_Support (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    issue_type VARCHAR(255) NOT NULL,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Content (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    release_date DATE,
    rating INT CHECK (rating BETWEEN 1 AND 10),  -- Ensures valid ratings
    language VARCHAR(50),
    duration INT  -- Duration in minutes
);


CREATE TABLE IF NOT EXISTS Watch_History (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    watch_time TIME,
    progress VARCHAR(50),  -- Progress tracking (e.g., "50% watched")
    last_watched TIME,
    FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 10),  -- Ratings between 1 and 10
    comment TEXT,
    review_date DATE NOT NULL,
    FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Watchlist (
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (profile_id, content_id),
    FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Recommendations (
    recommendation_id INT PRIMARY KEY AUTO_INCREMENT,
    profile_id INT NOT NULL,
    content_id INT NOT NULL,
    view_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (profile_id) REFERENCES Profiles(profile_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Episodes (
    episode_id INT PRIMARY KEY AUTO_INCREMENT,
    content_id INT NOT NULL,
    season_number INT,
    episode_number INT,
    duration INT,  -- Duration in minutes
    FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Content_Licensing (
    license_id INT PRIMARY KEY AUTO_INCREMENT,
    content_id INT NOT NULL,
    region VARCHAR(100),
    start_date DATE,
    end_date DATE,
    license_holder VARCHAR(255),
    FOREIGN KEY (content_id) REFERENCES Content(content_id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Persons (
    person_id INT PRIMARY KEY,
    name VARCHAR(255),
    biography TEXT
);


CREATE TABLE IF NOT EXISTS Actors_Directors (
    person_id INT,
    content_id INT,
    role VARCHAR(50),
    PRIMARY KEY (person_id, content_id, role),
    FOREIGN KEY (person_id) REFERENCES Persons(person_id),
    FOREIGN KEY (content_id) REFERENCES Content(content_id)
);



# ---------------------------------- INSERT COMMANDS ---------------------------------- #

INSERT INTO Subscription_Plans (plan_id, plan_name, price, duration, device_limit)
VALUES 
(1, 'Basic', 5, 30, 1),
(2, 'Standard', 10, 30, 3),
(3, 'Premium', 15, 30, 5);


INSERT INTO Advertisement (ad_id, ad_name, ad_duration, category, target_region) VALUES
(1, 'Tech Ad 1', 30, 'Technology', 'USA'),
(2, 'Food Ad 1', 25, 'Food', 'Europe'),
(3, 'Gaming Ad 1', 40, 'Entertainment', 'Asia'),
(4, 'Fashion Ad', 20, 'Lifestyle', 'USA'),
(5, 'Sports Ad', 35, 'Sports', 'UK'),
(6, 'Finance Ad', 28, 'Finance', 'Canada'),
(7, 'Travel Ad', 32, 'Travel', 'Australia'),
(8, 'Education Ad', 27, 'Education', 'India'),
(9, 'Health Ad', 33, 'Healthcare', 'Germany'),
(10, 'Tech Ad 2', 29, 'Technology', 'Japan'),
(11, 'Food Ad 2', 24, 'Food', 'France'),
(12, 'Gaming Ad 2', 39, 'Entertainment', 'Brazil'),
(13, 'Fitness Ad', 31, 'Fitness', 'South Korea'),
(14, 'Real Estate Ad', 26, 'Real Estate', 'UAE'),
(15, 'Automobile Ad', 34, 'Automobile', 'Italy'),
(16, 'Automobile Ad 2', 32, 'Automobile', 'Germany'),
(17, 'Education Ad', 25, 'Education', 'USA'),
(18, 'Entertainment Ad', 27, 'Entertainment', 'India'),
(19, 'Inspirational Ad', 40, 'Education', 'China'),
(20, 'Food Ad', 20, 'Food', 'Japan');


INSERT INTO User (user_id, name, email, password, plan_id, country, date_of_birth) VALUES
(1, 'Alice Johnson', 'alice1@example.com', 'hashed_password1', 1, 'USA', '1990-05-14'),
(2, 'Bob Smith', 'bob2@example.com', 'hashed_password2', 3, 'UK', '1985-10-20'),
(3, 'Charlie Davis', 'charlie3@example.com', 'hashed_password3', 3, 'Canada', '1992-07-01'),
(4, 'Daniel Martinez', 'daniel4@example.com', 'hashed_password4', 2, 'Spain', '1995-06-23'),
(5, 'Emily White', 'emily5@example.com', 'hashed_password5', 2, 'France', '1988-11-12'),
(6, 'Frank Harris', 'frank6@example.com', 'hashed_password6', 3, 'Germany', '1993-09-15'),
(7, 'Grace Lee', 'grace7@example.com', 'hashed_password7', 1, 'South Korea', '1991-03-28'),
(8, 'Henry Kim', 'henry8@example.com', 'hashed_password8', 1, 'Japan', '1987-08-17'),
(9, 'Isabella Brown', 'isabella9@example.com', 'hashed_password9', 3, 'Italy', '1994-02-04'),
(10, 'Jack Wilson', 'jack10@example.com', 'hashed_password10', 2, 'Australia', '1996-12-09'),
(11, 'Karen Thompson', 'karen11@example.com', 'hashed_password11', 2, 'India', '1989-07-21'),
(12, 'Leo Walker', 'leo12@example.com', 'hashed_password12', 3, 'Brazil', '1997-01-30'),
(13, 'Mia Scott', 'mia13@example.com', 'hashed_password13', 1, 'Russia', '1992-05-11'),
(14, 'Nathan Moore', 'nathan14@example.com', 'hashed_password14', 1, 'UAE', '1986-04-22'),
(15, 'Olivia King', 'olivia15@example.com', 'hashed_password15', 2, 'South Africa', '1995-10-05');


INSERT INTO Profiles (profile_id, user_id, profile_name, age_restriction, preferred_language, last_active_device) VALUES
(1, 1, 'Alice Main', '13+', 'English', 'Laptop'),
(16, 1, 'Alice Children', '7+', 'English', 'Phone'),
(20, 1, 'Alice & Mark', '16+', 'English', 'TV'),
(2, 2, 'Bob Family', '16+', 'French', 'Smart TV'),
(18, 2, 'Bob Family 2', '18+', 'Spanish', 'iPad'),
(3, 3, 'Charlie Mobile', 'All', 'Spanish', 'Phone'),
(17, 3, 'Charles', '13+', 'Spanish', 'Smart TV'),
(21, 3, 'Martha', 'All', 'Spanish', 'iPad'),
(19, 3, 'Jeromy', '7+', 'Spanish', 'Tablet'),
(4, 4, 'Daniel Main', 'All', 'English', 'Tablet'),
(5, 5, 'Emily Kids', '7+', 'French', 'iPad'),
(23, 5, 'Emilie', '7+', 'French', 'Phone'),
(6, 6, 'Frank Cinema', '18+', 'German', 'TV'),
(7, 7, 'Grace Anime', 'All', 'Japanese', 'PC'),
(22, 7, 'Grace Movies', '18+', 'Korean', 'TV'),
(25, 7, 'Grace Shows', '16+', 'English', 'Smart TV'),
(8, 8, 'Henry Music', 'All', 'Japanese', 'Phone'),
(24, 8, 'Kids', '7+', 'French', 'PC'),
(9, 9, 'Isabella Home', '13+', 'Italian', 'Smart TV'),
(26, 9, 'Isabella Shows', '18+', 'German', 'iPad'),
(10, 10, 'Jack Sports', '18+', 'English', 'Laptop'),
(11, 11, 'Karen', 'All', 'English', 'Tablet'),
(27, 11, 'Karen Kids', 'All', 'English', 'Smart TV'),
(28, 11, 'Andrew', 'All', 'English', 'Smart TV'),
(29, 11, 'Family', 'All', 'English', 'Smart TV'),
(12, 12, 'Leo Movies', '16+', 'Portuguese', 'PC'),
(13, 13, 'Mia Shows', '13+', 'Russian', 'Smart TV'),
(14, 14, 'Nathan Horror', '18+', 'Arabic', 'Phone'),
(30, 14, 'Nathan Anime', '18+', 'Japanese', 'Phone'),
(15, 15, 'Olivia Classic', 'All', 'Afrikaans', 'TV'),
(31, 15, 'Olivias', '18+', 'Afrikaans', 'iPad'),
(32, 15, 'Oli', 'All', 'Afrikaans', 'Phone');


INSERT INTO Content (content_id, title, genre, release_date, rating, language, duration) VALUES
(1, 'The Great Adventure', 'Action', '2023-10-15', 9, 'English', 120),
(2, 'Comedy Night', 'Comedy', '2023-12-01', 8, 'French', 90),
(3, 'Sci-Fi Galaxy', 'Sci-Fi', '2023-09-05', 7, 'English', 1440),
(4, 'Romantic Love', 'Romance', '2022-02-14', 6, 'Spanish', 480),
(5, 'Horror House', 'Horror', '2021-10-31', 8, 'German', 100),
(6, 'Fantasy World', 'Fantasy', '2023-08-22', 9, 'Italian', 3000),
(7, 'Detective Mystery', 'Mystery', '2023-11-30', 8, 'French', 105),
(8, 'Western Cowboy', 'Western', '2020-07-01', 7, 'English', 115),
(9, 'History Revisited', 'History', '2023-06-12', 9, 'Portuguese', 300),
(10, 'Thriller Chase', 'Thriller', '2022-12-05', 8, 'Hindi', 110),
(11, 'Drama Tears', 'Drama', '2021-05-20', 9, 'Korean', 135),
(12, 'Epic Saga', 'Epic', '2022-09-15', 10, 'Japanese', 225),
(13, 'Science Explained', 'Documentary', '2023-03-25', 9, 'English', 90),
(14, 'Sports Legends', 'Sports', '2022-04-10', 7, 'Spanish', 95),
(15, 'Musical Journey', 'Musical', '2023-07-30', 8, 'French', 100);


INSERT INTO Episodes (episode_id, content_id, season_number, episode_number, duration) VALUES
(1, 3, 3, 8, 60),
(2, 4, 2, 8, 30),
(3, 6, 5, 10, 60),
(4, 9, 1, 5, 60),
(5, 12, 1, 5, 45);


INSERT INTO Content_Licensing (license_id, content_id, region, start_date, end_date, license_holder) VALUES
(1, 1, 'USA', '2023-01-01', '2025-12-31', 'Netflix'),
(2, 2, 'Europe', '2023-06-01', '2026-06-01', 'Disney'),
(3, 3, 'Canada', '2023-05-01', '2027-05-01', 'Amazon Prime'),
(4, 4, 'Spain', '2023-09-15', '2028-09-15', 'Hotstar'),
(5, 5, 'Europe', '2022-11-10', '2025-11-10', 'BBC iPlayer'),
(6, 6, 'Europe', '2023-07-12', '2027-07-12', 'Stan'),
(7, 7, 'France', '2023-10-01', '2026-10-01', 'Hulu'),
(8, 8, 'Australia', '2023-08-05', '2026-08-05', 'ZDF'),
(9, 9, 'USA', '2022-12-20', '2025-12-20', 'Globoplay'),
(10, 10, 'India', '2023-03-11', '2026-03-11', 'ivi.ru'),
(11, 11, 'South Korea', '2023-04-30', '2026-04-30', 'Canal+'),
(12, 12, 'Japan', '2023-01-15', '2026-01-15', 'Wavve'),
(13, 13, 'Mexico', '2023-09-10', '2027-09-10', 'Blim TV'),
(14, 14, 'Spain', '2022-10-01', '2025-10-01', 'OSN'),
(15, 15, 'France', '2023-11-05', '2028-11-05', 'Showmax'),
(16, 1, 'France', '2022-10-05', '2027-11-05', 'Canal+'),
(17, 4, 'Australia', '2024-08-06', '2025-10-06', 'BBC iPlayer'),
(18, 7, 'India', '2023-08-05', '2026-08-05', 'Hulu'),
(19, 10, 'Japan', '2023-06-01', '2026-06-01', 'Disney'),
(20, 10, 'South Korea', '2023-08-05', '2026-08-05', 'Globoplay'),
(21, 13, 'Europe', '2023-07-12', '2027-07-12', 'Hotstar'),
(22, 13, 'Canada', '2023-07-12', '2027-07-12', 'Sparta TV'),
(23, 13, 'Spain', '2023-09-15', '2028-09-15', 'Blim TV'),
(24, 13, 'Africa', '2023-08-05', '2026-08-05', 'ivi.ru'),
(25, 15, 'Spain', '2023-01-15', '2026-01-15', 'Hulu'),
(26, 15, 'USA', '2023-01-15', '2026-01-15', 'ZDF'),
(27, 6, 'India', '2023-03-11', '2026-03-11', 'ZDF'),
(28, 6, 'France', '2024-09-21', '2028-03-30', 'Globoplay'),
(29, 6, 'Japan', '2023-08-05', '2026-08-05', 'Hotstar'),
(30, 6, 'South Korea', '2024-08-06', '2025-10-06', 'Hotstar');


INSERT INTO Payments (payment_id, user_id, plan_id, amount, payment_date, payment_method) VALUES
(1, 1, 1, 5.00, '2024-02-01 10:00:00', 'Credit Card'),
(2, 2, 3, 10.00, '2024-02-05 15:30:00', 'PayPal'),
(3, 3, 3, 15.00, '2024-02-10 09:45:00', 'Debit Card'),
(4, 4, 2, 5.00, '2024-02-15 12:10:00', 'Credit Card'),
(5, 5, 2, 10.00, '2024-02-20 14:30:00', 'PayPal'),
(6, 6, 3, 15.00, '2024-02-25 11:15:00', 'Other'),
(7, 7, 1, 5.00, '2024-03-01 08:20:00', 'Credit Card'),
(8, 8, 1, 10.00, '2024-03-05 18:00:00', 'PayPal'),
(9, 9, 3, 15.00, '2024-03-10 07:50:00', 'Debit Card'),
(10, 10, 2, 5.00, '2024-03-15 09:40:00', 'Other'),
(11, 11, 2, 10.00, '2024-03-20 14:50:00', 'Credit Card'),
(12, 12, 3, 15.00, '2024-03-25 10:30:00', 'PayPal'),
(13, 13, 1, 5.00, '2024-04-01 16:15:00', 'Debit Card'),
(14, 14, 1, 10.00, '2024-04-05 13:00:00', 'Other'),
(15, 15, 2, 15.00, '2024-04-10 12:45:00', 'Credit Card');


INSERT INTO Reviews (review_id, profile_id, content_id, rating, comment, review_date) VALUES
(1, 6, 6, 9, 'Amazing movie!', '2024-02-01'),
(2, 7, 10, 5, 'Could have been better.', '2023-01-20'),
(3, 8, 8, 7, 'Better than expected', '2024-07-30'),
(4, 10, 10, 8, 'Pretty good, enjoyed it.', '2023-02-05'),
(5, 11, 10, 7, 'Liked it', '2024-02-04'),
(6, 11, 2, 7, 'It was okay, some parts were boring.', '2024-02-10'),
(7, 11, 4, 6, 'Not my taste.', '2024-02-15'),
(8, 11, 8, 9, 'Excellent storytelling!', '2024-02-20'),
(9, 11, 15, 2, 'Hated it', '2024-02-21'),
(10, 14, 12, 10, 'Amazing!!', '2023-01-15'),
(11, 16, 11, 10, 'Best movie ever!', '2024-02-25'),
(12, 20, 1, 5, 'Boringgggg!', '2022-08-06'),
(13, 20, 14, 8, 'Decent watch.', '2024-03-01'),
(14, 24, 12, 6, 'Okay.', '2024-03-02'),
(15, 24, 10, 9, 'Liked it!', '2023-10-03'),
(16, 24, 1, 4, 'Seen better', '2023-06-10'),
(17, 27, 5, 7, 'Cool effects but lacked depth.', '2024-03-05'),
(18, 29, 8, 6, 'A bit too long for me.', '2024-03-10'),
(19, 32, 14, 10, 'Best movie ever!!!', '2022-09-27'),
(20, 32, 9, 9, 'Highly recommended!', '2024-03-15');



INSERT INTO Watchlist (profile_id, content_id, added_date) VALUES
(1, 1, '2024-02-01 09:00:00'),
(1, 15, '2024-02-01 09:00:00'),
(2, 15, '2024-02-08 14:20:00'),
(2, 11, '2024-02-08 14:20:00'),
(2, 2, '2024-02-08 14:20:00'),
(3, 4, '2024-02-12 16:10:00'),
(3, 1, '2024-02-12 16:10:00'),
(4, 4, '2024-02-15 10:30:00'),
(4, 10, '2024-02-15 10:30:00'),
(4, 11, '2024-02-15 10:30:00'),
(4, 15, '2024-02-15 10:30:00'),
(4, 14, '2024-02-15 10:30:00'),
(5, 1, '2024-02-20 12:45:00'),
(5, 6, '2024-02-20 12:45:00'),
(6, 6, '2024-02-25 09:50:00'),
(7, 7, '2024-03-01 17:30:00'),
(7, 10, '2024-03-01 17:30:00'),
(8, 8, '2024-03-05 14:10:00'),
(9, 9, '2024-03-10 20:00:00'),
(9, 10, '2024-03-10 20:00:00'),
(9, 4, '2024-03-10 20:00:00'),
(10, 10, '2024-03-15 13:15:00'),
(10, 11, '2024-03-15 13:15:00'),
(11, 11, '2024-03-20 15:25:00'),
(12, 12, '2024-03-25 18:40:00'),
(13, 13, '2024-04-01 16:10:00'),
(14, 14, '2024-04-05 19:55:00'),
(14, 13, '2024-04-05 19:55:00'),
(14, 12, '2024-04-05 19:55:00'),
(14, 11, '2024-04-05 19:55:00'),
(14, 15, '2024-04-05 19:55:00'),
(14, 9, '2024-04-05 19:55:00'),
(14, 1, '2024-04-05 19:55:00'),
(15, 15, '2024-04-10 11:30:00'),
(16, 2, '2024-04-10 11:30:00'),
(17, 15, '2024-04-10 11:30:00'),
(18, 12, '2024-04-10 11:30:00'),
(18, 2, '2024-04-10 11:30:00'),
(19, 9, '2024-04-10 11:30:00'),
(19, 3, '2024-04-10 11:30:00'),
(19, 4, '2024-04-10 11:30:00'),
(20, 1, '2024-04-10 11:30:00'),
(21, 1, '2024-04-10 11:30:00'),
(21, 6, '2024-04-10 11:30:00'),
(22, 1, '2024-04-10 11:30:00'),
(22, 10, '2024-04-10 11:30:00'),
(22, 7, '2024-04-10 11:30:00'),
(23, 1, '2024-04-10 11:30:00'),
(23, 10, '2024-04-10 11:30:00'),
(24, 10, '2024-04-10 11:30:00'),
(24, 11, '2024-04-10 11:30:00'),
(24, 1, '2024-04-10 11:30:00'),
(25, 1, '2024-04-10 11:30:00'),
(26, 1, '2024-04-10 11:30:00'),
(27, 1, '2024-04-10 11:30:00'),
(27, 10, '2024-04-10 11:30:00'),
(27, 2, '2024-04-10 11:30:00'),
(27, 3, '2024-04-10 11:30:00'),
(27, 6, '2024-04-10 11:30:00'),
(28, 9, '2024-04-10 11:30:00'),
(28, 14, '2024-04-10 11:30:00'),
(28, 2, '2024-04-10 11:30:00'),
(29, 9, '2024-04-10 11:30:00'),
(29, 8, '2024-04-10 11:30:00'),
(30, 1, '2024-04-10 11:30:00'),
(30, 4, '2024-04-10 11:30:00'),
(30, 2, '2024-04-10 11:30:00'),
(31, 13, '2024-04-10 11:30:00'),
(32, 1, '2024-04-10 11:30:00'),
(32, 13, '2024-04-10 11:30:00'),
(32, 9, '2024-04-10 11:30:00'),
(32, 14, '2024-04-10 11:30:00');


INSERT INTO Recommendations (recommendation_id, profile_id, content_id, view_date) VALUES
(1, 10, 2, '2024-02-09 13:10:00'),
(2, 10, 4, '2024-02-11 11:45:00'),
(3, 3, 15, '2024-02-14 15:00:00'),
(4, 14, 10, '2024-02-18 12:25:00'),
(5, 32, 10, '2024-02-22 09:35:00'),
(6, 30, 7, '2024-02-27 14:50:00'),
(7, 32, 8, '2024-03-02 17:15:00'),
(8, 7, 1, '2024-03-06 10:40:00'),
(9, 7, 5, '2024-03-12 08:30:00'),
(10, 7, 14, '2024-03-16 12:55:00'),
(11, 28, 12, '2024-03-22 18:10:00'),
(12, 20, 13, '2024-03-27 19:45:00'),
(13, 31, 2, '2024-04-02 14:20:00'),
(14, 20, 9, '2024-04-07 11:50:00'),
(15, 29, 10, '2024-04-12 16:30:00'),
(16, 4, 1, '2024-04-12 16:30:00'),
(17, 4, 6, '2024-04-12 16:30:00'),
(18, 9, 15, '2024-04-12 16:30:00'),
(19, 18, 7, '2024-04-12 16:30:00'),
(20, 23, 13, '2024-04-12 16:30:00'),
(21, 2, 11, '2024-04-12 16:30:00'),
(22, 2, 6, '2024-04-12 16:30:00'),
(23, 18, 13, '2024-04-12 16:30:00'),
(24, 3, 13, '2024-04-12 16:30:00'),
(25, 17, 10, '2024-04-12 16:30:00'),
(26, 21, 1, '2024-04-12 16:30:00'),
(27, 26, 3, '2024-04-12 16:30:00'),
(28, 9, 4, '2024-04-12 16:30:00'),
(29, 3, 3, '2024-04-12 16:30:00'),
(30, 9, 4, '2024-04-12 16:30:00'),
(31, 2, 11, '2024-04-12 16:30:00');


INSERT INTO Devices (device_id, user_id, device_type, os, ip_address, last_login) VALUES
(1, 1, 'Laptop', 'Windows', '192.168.1.2', '12:30:00'),
(2, 1, 'TV', 'Android', '192.168.1.3', '14:10:00'),
(3, 1, 'Phone', 'iOS', '192.168.1.4', '15:45:00'),
(4, 2, 'iPad', 'iPadOS', '192.168.1.5', '10:20:00'),
(5, 2, 'Smart TV', 'Tizen', '192.168.1.6', '18:15:00'),
(6, 3, 'Smart TV', 'Android', '192.168.1.7', '20:30:00'),
(7, 3, 'Phone', 'Android', '192.168.1.8', '22:50:00'),
(8, 3, 'Tablet', 'Android', '192.168.1.9', '09:25:00'),
(9, 3, 'iPad', 'iPadOS', '192.168.1.10', '16:35:00'),
(10, 4, 'Tablet', 'Android', '192.168.1.11', '13:10:00'),
(11, 5, 'iPad', 'iPadOS', '192.168.1.12', '19:45:00'),
(12, 5, 'Phone', 'Android', '192.168.1.13', '17:20:00'),
(13, 6, 'TV', 'Android', '192.168.1.14', '15:55:00'),
(14, 7, 'PC', 'MacOS', '192.168.1.15', '11:30:00'),
(15, 7, 'Smart TV', 'Tizen', '192.168.1.16', '15:55:01'),
(16, 7, 'TV', 'Android', '192.168.1.17', '23:43:00'),
(17, 8, 'Phone', 'iOS', '192.168.1.18', '22:50:00'),
(18, 8, 'PC', 'Windows', '192.169.1.1', '17:55:00'),
(19, 9, 'Smart TV', 'Android', '192.169.1.2', '20:30:00'),
(20, 9, 'iPad', 'iPadOS', '192.169.1.3', '23:40:00'),
(21, 10, 'Laptop', 'iOS', '192.169.1.4', '20:40:00'),
(22, 11, 'Tablet', 'iOS', '193.170.1.1', '01:20:30'),
(23, 11, 'Smart TV', 'Tizen', '193.170.1.2', '20:40:00'),
(24, 11, 'Smart TV', 'Android', '193.170.1.3', '14:50:00'),
(25, 11, 'Smart TV', 'Tizen', '193.170.1.4', '13:00:00'),
(26, 12, 'PC', 'MacOS', '193.171.1.1', '21:50:00'),
(27, 13, 'Smart TV', 'Android', '193.171.1.2', '16:10:00'),
(28, 14, 'Phone', 'iOS', '193.171.1.3', '18:40:00'),
(29, 14, 'Phone', 'Android', '192.180.1.16', '20:45:00'),
(30, 15, 'TV', 'Android', '192.180.1.20', '18:40:00'),
(31, 15, 'iPad', 'iPadOS', '192.180.1.14', '07:50:00'),
(32, 15, 'Phone', 'Android', '192.180.1.60', '09:10:00');


INSERT INTO Persons (person_id, name, biography) VALUES
(1, 'John Doe', 'Famous director known for action films.'),
(2, 'Jane Smith', 'Comedy actress with multiple awards.'),
(3, 'Michael Johnson', 'Screenwriter for sci-fi movies.'),
(4, 'Emily White', 'Director and producer of romance films.'),
(5, 'David Brown', 'Known for thriller and horror genres.'),
(6, 'Sarah Davis', 'Critically acclaimed documentary filmmaker.'),
(7, 'James Wilson', 'Musician and actor in musicals.'),
(8, 'Olivia Taylor', 'Award-winning foreign film director.'),
(9, 'Daniel Martinez', 'Versatile actor in drama and action.'),
(10, 'Sophia Thomas', 'Voice-over artist in animated movies.'),
(11, 'Matthew Harris', 'Director of famous crime series.'),
(12, 'Emma Scott', 'Known for producing historical epics.'),
(13, 'Liam Walker', 'Comedy writer and stand-up performer.'),
(14, 'Ava Lee', 'Multi-talented actor and producer.'),
(15, 'Ethan King', 'Oscar-winning screenplay writer.');


INSERT INTO Actors_Directors (person_id, content_id, role) VALUES
(1, 1, 'Director'),
(1, 3, 'Director'),
(2, 4, 'Actor'),
(2, 15, 'Actor'),
(2, 10, 'Actor'),
(3, 15, 'Producer'),
(3, 10, 'Producer'),
(3, 6, 'Producer'),
(3, 3, 'Producer'),
(3, 9, 'Producer'),
(4, 4, 'Actor'),
(4, 2, 'Actor'),
(4, 1, 'Actor'),
(4, 11, 'Actor'),
(5, 5, 'Director'),
(5, 13, 'Director'),
(6, 12, 'Writer'),
(7, 7, 'Actor'),
(7, 9, 'Actor'),
(8, 10, 'Director'),
(8, 14, 'Director'),
(8, 15, 'Director'),
(8, 4, 'Director'),
(8, 8, 'Director'),
(9, 6, 'Actor'),
(9, 9, 'Actor'),
(10, 10, 'Producer'),
(10, 15, 'Producer'),
(10, 12, 'Producer'),
(11, 11, 'Writer'),
(11, 15, 'Writer'),
(12, 6, 'Director'),
(13, 13, 'Actor'),
(13, 12, 'Actor'),
(13, 10, 'Actor'),
(13, 11, 'Actor'),
(13, 7, 'Actor'),
(14, 6, 'Producer'),
(14, 4, 'Producer'),
(14, 3, 'Producer'),
(14, 12, 'Producer'),
(14, 15, 'Producer'),
(14, 1, 'Producer'),
(15, 10, 'Actor'),
(15, 15, 'Actor');


INSERT INTO AD_views (ad_view_id, user_id, ad_id, view_date) VALUES
(101, 1, 1, '2024-02-05 14:30:00'),
(201, 2, 2, '2024-02-07 12:00:00'),
(301, 3, 3, '2024-02-10 15:20:00'),
(401, 4, 4, '2024-02-12 09:45:00'),
(501, 5, 5, '2024-02-14 18:30:00'),
(601, 6, 6, '2024-02-16 13:15:00'),
(701, 7, 7, '2024-02-18 21:00:00'),
(801, 8, 8, '2024-02-20 17:10:00'),
(901, 9, 9, '2024-02-22 14:40:00'),
(1001, 10, 10, '2024-02-24 10:55:00'),
(1101, 11, 11, '2024-02-26 19:25:00'),
(1201, 12, 12, '2024-02-28 16:50:00'),
(1301, 13, 13, '2024-03-02 09:30:00'),
(1401, 14, 14, '2024-03-04 11:20:00'),
(1501, 15, 15, '2024-03-06 20:15:00');


INSERT INTO Basic (plan_id, ad_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), 
(1, 6), (1, 7), (1, 8), (1, 9), (1, 10), 
(1, 11), (1, 12), (1, 13), (1, 14), (1, 15),
(1, 16), (1, 17), (1, 18), (1, 19), (1, 20);


INSERT INTO Standard (plan_id, offline_download) VALUES
(2, TRUE);


INSERT INTO Premium (plan_id, spatial_audio_support) VALUES
(3, TRUE);


INSERT INTO Customer_Support (ticket_id, user_id, issue_type, status, created_at, resolved_at) VALUES
(1, 1, 'Billing Issue', 'Resolved', '2024-02-10 12:00:00', '2024-02-12 14:00:00'),
(2, 2, 'Streaming Issue', 'Open', '2024-02-15 18:30:00', NULL),
(5, 5, 'Payment Error', 'Resolved', '2024-02-24 14:20:00', '2024-02-26 11:30:00'),
(6, 6, 'Content Not Available', 'Open', '2024-02-27 10:00:00', NULL),
(10, 10, 'Account Hacked', 'Open', '2024-03-10 19:15:00', NULL),
(15, 15, 'Parental Control Issue', 'Closed', '2024-03-22 08:30:00', '2024-03-24 10:55:00');


INSERT INTO Watch_History (history_id, profile_id, content_id, watch_time, progress, last_watched) VALUES
(1, 1, 1, '02:30:00', '75%', '20:00:00'),
(2, 1, 14, '01:30:00', '75%', '20:00:00'),
(3, 2, 11, '00:45:00', '95%', '18:00:00'),
(4, 2, 15, '04:40:00', '50%', '18:00:00'),
(5, 2, 2, '02:00:00', '50%', '18:00:00'),
(6, 3, 3, '00:10:00', '90%', '22:30:00'),
(7, 4, 4, '10:50:00', '95%', '19:45:00'),
(8, 4, 10, '15:30:00', '60%', '19:45:00'),
(9, 5, 5, '14:20:00', '30%', '17:20:00'),
(10, 5, 1, '12:50:00', '95%', '17:20:00'),
(11, 5, 7, '05:40:00', '30%', '17:20:00'),
(12, 6, 6, '04:45:00', '100%', '21:10:00'),
(13, 6, 10, '09:55:00', '80%', '21:10:00'),
(14, 7, 7, '15:10:00', '85%', '23:00:00'),
(15, 7, 10, '13:20:00', '95%', '23:00:00'),
(16, 8, 8, '08:30:00', '100%', '18:40:00'),
(17, 9, 9, '05:50:00', '40%', '16:30:00'),
(18, 9, 10, '02:40:00', '40%', '16:30:00'),
(19, 9, 4, '00:40:00', '40%', '16:30:00'),
(20, 10, 10, '01:35:00', '100%', '20:50:00'),
(21, 10, 12, '02:35:00', '70%', '20:50:00'),
(22, 11, 10, '05:50:00', '95%', '23:20:00'),
(23, 11, 2, '09:20:00', '95%', '23:20:00'),
(24, 11, 4, '06:05:00', '95%', '23:20:00'),
(25, 11, 8, '13:05:00', '95%', '23:20:00'),
(26, 11, 15, '02:30:00', '95%', '23:20:00'),
(27, 12, 12, '12:40:00', '35%', '17:00:00'),
(28, 12, 10, '01:30:00', '35%', '17:00:00'),
(29, 13, 10, '08:45:00', '65%', '19:30:00'),
(30, 13, 7, '05:55:00', '65%', '19:30:00'),
(31, 13, 2, '12:30:00', '65%', '19:30:00'),
(32, 14, 12, '13:40:00', '100%', '15:40:00'),
(33, 14, 11, '04:30:00', '24%', '15:40:00'),
(34, 15, 15, '06:30:00', '6%', '22:10:00'),
(35, 16, 14, '03:10:00', '90%', '15:40:00'),
(36, 16, 11, '07:20:00', '100%', '15:40:00'),
(37, 17, 15, '01:45:00', '21%', '15:40:00'),
(38, 17, 14, '02:30:00', '45%', '15:40:00'),
(39, 18, 14, '12:30:00', '50%', '15:40:00'),
(40, 19, 14, '01:30:00', '5%', '15:40:00'),
(41, 20, 1, '06:40:00', '100%', '15:40:00'),
(42, 20, 14, '05:45:00', '100%', '15:40:00'),
(43, 20, 6, '03:22:00', '30%', '15:40:00'),
(44, 20, 2, '07:20:00', '75%', '15:40:00'),
(45, 21, 1, '01:40:00', '80%', '15:40:00'),
(46, 21, 6, '15:10:00', '85%', '15:40:00'),
(47, 21, 10, '01:10:00', '25%', '15:40:00'),
(48, 22, 11, '03:50:00', '30%', '15:40:00'),
(49, 23, 10, '09:50:00', '45%', '15:40:00'),
(50, 23, 11, '01:50:00', '50%', '15:40:00'),
(51, 24, 12, '04:40:00', '100%', '15:40:00'),
(52, 24, 10, '02:45:00', '100%', '15:40:00'),
(53, 24, 2, '02:40:00', '20%', '15:40:00'),
(54, 24, 1, '02:30:00', '100%', '15:40:00'),
(55, 25, 1, '01:40:00', '25%', '15:40:00'),
(56, 25, 13, '06:20:00', '25%', '15:40:00'),
(57, 26, 1, '09:40:00', '30%', '15:40:00'),
(58, 26, 6, '10:10:00', '45%', '15:40:00'),
(59, 26, 5, '02:20:00', '50%', '15:40:00'),
(60, 27, 5, '12:20:00', '100%', '15:40:00'),
(61, 28, 14, '13:55:00', '90%', '15:40:00'),
(62, 29, 8, '06:50:00', '95%', '15:40:00'),
(63, 29, 9, '02:10:00', '70%', '15:40:00'),
(64, 30, 14, '15:30:00', '60%', '15:40:00'),
(65, 31, 14, '12:45:00', '20%', '15:40:00'),
(66, 31, 13, '08:40:00', '40%', '15:40:00'),
(67, 31, 1, '06:20:00', '50%', '15:40:00'),
(68, 32, 14, '13:40:00', '100%', '15:40:00'),
(69, 32, 9, '14:50:00', '100%', '15:40:00');



# ---------------------------------- ANALYSIS ---------------------------------- #
### 1. Top & Bottom Performing Genres by Watch Hours Across Countries
WITH WatchTimePerCountry AS (
    SELECT u.country, c.genre, 
           SUM(TIME_TO_SEC(wh.watch_time)/3600) AS total_watch_hours
    FROM Watch_History wh
    JOIN Profiles p ON wh.profile_id = p.profile_id
    JOIN `User` u ON p.user_id = u.user_id
    JOIN Content c ON wh.content_id = c.content_id
    GROUP BY u.country, c.genre
), 
RecommendationsPerCountry AS (
    SELECT u.country, c.genre, COUNT(r.recommendation_id) AS total_recommendations
    FROM Recommendations r
    JOIN Profiles p ON r.profile_id = p.profile_id
    JOIN `User` u ON p.user_id = u.user_id
    JOIN Content c ON r.content_id = c.content_id
    GROUP BY u.country, c.genre
),
RankedWatchTime AS (
    SELECT w.country, w.genre, w.total_watch_hours, 
           COALESCE(r.total_recommendations, 0) AS total_recommendations
    FROM WatchTimePerCountry w
    LEFT JOIN RecommendationsPerCountry r 
    ON w.country = r.country AND w.genre = r.genre
)

(
    SELECT * FROM RankedWatchTime
    ORDER BY total_watch_hours DESC
    LIMIT 3
)
UNION ALL
(
    SELECT * FROM RankedWatchTime
    ORDER BY total_watch_hours ASC
    LIMIT 3
);



### 2. Predicting Customer Retention Based on Support Resolution Time
WITH ResolutionTime AS (
    SELECT cs.user_id, 
           AVG(TIMESTAMPDIFF(HOUR, cs.created_at, cs.resolved_at)) AS avg_resolution_time,
           COUNT(cs.ticket_id) AS total_issues
    FROM Customer_Support cs
    WHERE cs.status = 'Resolved'
    GROUP BY cs.user_id
),
PaymentActivity AS (
    SELECT u.user_id, COUNT(p.payment_id) AS total_payments
    FROM Payments p
    JOIN `User` u ON p.user_id = u.user_id
    GROUP BY u.user_id
)
SELECT r.user_id, u.name, u.country, sp.plan_name, 
       r.total_issues, r.avg_resolution_time, 
       COALESCE(pa.total_payments, 0) AS payment_count
FROM ResolutionTime r
JOIN `User` u ON r.user_id = u.user_id
JOIN Subscription_Plans sp ON u.plan_id = sp.plan_id
LEFT JOIN PaymentActivity pa ON r.user_id = pa.user_id
WHERE r.avg_resolution_time > 48
  AND COALESCE(pa.total_payments, 0) < 2
ORDER BY avg_resolution_time DESC;



### 3. Calculate total revenue generated by users who watched ads in each category along with the peak hours
WITH AdRevenue AS (
    SELECT a.category, 
           SUM(p.amount) AS total_revenue,
           COUNT(av.ad_view_id) AS total_ad_views
    FROM AD_views av
    JOIN Advertisement a ON av.ad_id = a.ad_id
    JOIN Payments p ON av.user_id = p.user_id
    GROUP BY a.category
),
PeakAdHours AS (
    SELECT a.category, 
           HOUR(av.view_date) AS peak_hour
    FROM AD_views av
    JOIN Advertisement a ON av.ad_id = a.ad_id
    GROUP BY a.category, peak_hour
    ORDER BY a.category, COUNT(av.ad_view_id) DESC
)
SELECT ar.category, 
       ar.total_revenue, 
       ar.total_ad_views, 
       pa.peak_hour
FROM AdRevenue ar
JOIN PeakAdHours pa ON ar.category = pa.category
WHERE pa.peak_hour = (
    SELECT HOUR(av.view_date)
    FROM AD_views av
    JOIN Advertisement a ON av.ad_id = a.ad_id
    WHERE a.category = pa.category
    GROUP BY HOUR(av.view_date)
    ORDER BY COUNT(av.ad_view_id) DESC
    LIMIT 1
)
ORDER BY ar.total_revenue DESC;
