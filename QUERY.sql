-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE users (
  user_id serial PRIMARY KEY,
  full_name varchar(100) NOT NULL,
  email varchar(100) UNIQUE NOT NULL,
  role varchar(20) NOT NULL DEFAULT 'Football Fan' CHECK (role IN ('Ticket Manager', 'Football Fan')),
  phone_number varchar(20)
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE matches (
  match_id serial PRIMARY KEY,
  fixture varchar(150) NOT NULL,
  tournament_category varchar(100) NOT NULL,
  base_ticket_price numeric(10, 2) CHECK (base_ticket_price >= 0),
  match_status varchar(20) DEFAULT 'Available' CHECK (
    match_status IN (
      'Available',
      'Selling Fast',
      'Sold Out',
      'Postponed'
    )
  )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE bookings (
  booking_id serial PRIMARY KEY,
  user_id int NOT NULL REFERENCES users (user_id),
  match_id int NOT NULL REFERENCES matches (match_id),
  seat_number varchar(20),
  payment_status varchar(20) DEFAULT 'Pending' CHECK (
    payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
  ),
  total_cost numeric(10, 2) NOT NULL CHECK (total_cost >= 0)
);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);


-- =========================================================================
-- Query 1: Answer
select match_id, fixture, base_ticket_price from matches where tournament_category = 'Champions League' and match_status = 'Available';
-- =========================================================================
-- Query 2: Answer
select user_id, full_name, email from users where full_name like 'Tanvir%' or full_name Ilike '%Haque%' ;
-- =========================================================================
-- Query 3: Answer
select
  booking_id,
  user_id,
  match_id,
  coalesce(payment_status, 'Action Required') as systematic_status
from
  bookings
where
  payment_status isnull;
-- =========================================================================
-- Query 4: Answer
select
  booking_id,
  full_name,
  fixture,
  total_cost
from
  bookings as b
  join users as u on b.user_id = u.user_id
  join matches as m on b.match_id = m.match_id;
-- =========================================================================
-- Query 5: Answer
select u.user_id, u.full_name, b.booking_id from users as u left join bookings as b on u.user_id = b.user_id;
-- =========================================================================
-- Query 6: Answer
select booking_id, match_id, total_cost from bookings where total_cost > (select avg(total_cost) from bookings);
-- =========================================================================
-- Query 7: Answer
select * from matches order by base_ticket_price desc limit 2 offset 1;