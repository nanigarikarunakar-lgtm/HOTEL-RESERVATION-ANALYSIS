-- Hotel Reservation Operations Analytics
-- creating database 

-- sprint - 1

create database Hotel_Reservation;

use Hotel_Reservation;

-- creating tables

-- hotels table creation

create table hotels (hotel_id varchar(50) primary key,
                      hotel_name varchar(50) not null,
                      city varchar(50) not null,
                      star_rating decimal(2,1) check (star_rating between 1 and 5),
                      total_rooms int not null,
                      opened_date date not null);

select * from hotels;

-- creating guests table

create table guests(guest_id varchar(50) primary key,
					guest_name varchar(100) not null,
                    city varchar(50) not null,
                    guest_type varchar(50) not null,
                    preferred_room_type varchar(50) not null,
                    loyalty_tier varchar(50) not null,
                    account_since date not null);

select * from guests;   

-- creating staff tyable

create table staff(staff_id varchar(30) primary key,	
				   staff_name varchar(100) not null,	
                   hire_date date not null,	
                   rating decimal(3,2) check(rating between 1 and 5),	
                   department varchar(30) not null,	
                   is_active varchar(20));    
                   
                   
select * from staff;     

-- creating rooms table

create table rooms(room_id varchar(20) primary key,
				   hotel_id varchar(50) ,
                   room_type varchar(30) not null,	
                   floor_number	int not null check(floor_number > 0),
                   max_occupancy int not null check (max_occupancy between 1 and 5),
				   price_per_night decimal(10,2) not null check(price_per_night >0),
                   is_active varchar(20) not null,
                   foreign key(hotel_id)
                   references hotels(hotel_id));

select * from rooms;              


create table bookings(booking_id varchar(20) primary key,	
                      guest_id varchar(50) not null,	
                      hotel_id	varchar(50) not null,
                      booking_date date not null,	
                      room_type_requested varchar(20) not null,
                      booking_channel varchar(30) not null,
                      nights_booked int not null CHECK (nights_booked > 0),	
                      total_amount decimal(10,2) CHECK (total_amount >= 0),
                      foreign key(guest_id)
                      references guests(guest_id),
                      foreign key(hotel_id)
                      references hotels(hotel_id));
                      
select * from bookings;


-- creation of stays table

create table stays(stay_id varchar(50) primary key,	
				   booking_id varchar(20) not null,
                   room_id varchar(20) not null,
                   staff_id varchar(30) not null,
                   check_in_date date not null,	
                   check_out_date date not null,	
                   status varchar(30) not null,
                   nights_stayed int not null check(nights_stayed >= 0),	
                   service_requests	 int not null check(service_requests >= 0),
                   stay_duration_hrs int not null check(stay_duration_hrs>= 0),
                   foreign key(booking_id)
                   references bookings(booking_id),
                   foreign key (room_id)
                   references rooms(room_id),
                   foreign key (staff_id)
                   references staff(staff_id)
				   );            
                   
                   
select * from stays;

-- Sprint 3: Basic Analysis / Data Exploration

-- 1. What is the total number of guests?

select count(guest_id) from guests;

-- What is the total number of bookings?

select count(booking_id) from bookings;

-- What is the total number of stays

select count(stay_id) from stays;

-- What are the different room types available?

select distinct room_type
FROM rooms;

-- How many staff members are currently active?

select * from staff where is_active = "yes";

-- 6. What are the different booking channels?

select distinct booking_channel from bookings;

-- What is the total booking amount across all bookings?

select sum(total_amount) from bookings;

-- 8. What is the average nights booked per booking?

select avg(nights_booked) as avg_nights_booked  from bookings;



select * from hotels;
select * from guests;
select * from staff;
select * from stays;
select * from rooms;
select * from bookings;

-- Sprint 4: Objective-Based Analysis

-- 4.1 Understand Booking Demand

-- How many bookings does each hotels received ?

select
    h.hotel_name,
    count(b.booking_id) as total_bookings
from hotels h
join bookings b
    on h.hotel_id = b.hotel_id
group by h.hotel_id, h.hotel_name
order by total_bookings desc;


-- - Which hotel has the highest number of bookings ?

select
    h.hotel_name,
    count(b.booking_id) as total_bookings
from hotels h
join bookings b
    on h.hotel_id = b.hotel_id
group by h.hotel_id, h.hotel_name
order by total_bookings desc
limit 1;

-- StayPoint Kolkata Residency	129


-- -- - Which hotel has the lowest number of bookings ?

select
    h.hotel_name,
    count(b.booking_id) as total_bookings
from hotels h
join bookings b
    on h.hotel_id = b.hotel_id
group by h.hotel_id, h.hotel_name
order by total_bookings asc
limit 1;

-- StayPoint Indore Retreat	98


-- which room_type is booked many times ?

select
    r.room_type,
    COUNT(*) as total_bookings
from bookings b
join stays s
    on b.booking_id = s.booking_id
join rooms r
    on s.room_id = r.room_id
group by r.room_type
order by  total_bookings desc
LIMIT 1;

-- Standard	1440

-- In which year staypint hotels received more orders

select
    YEAR(booking_date) AS booking_year,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY YEAR(booking_date)
ORDER BY total_bookings desc
LIMIT 1;


-- 2025	1048

-- In which year staty point hotels got less bookings

select
    YEAR(booking_date) AS booking_year,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY YEAR(booking_date)
ORDER BY total_bookings asc
LIMIT 1;

-- 2026	867


-- 4.2 Understand Guest Booking Behaviour

-- 1.how many bookings comes from each booking channel

 select booking_channel, count(booking_id) as channel_bookings
 from bookings
 group by booking_channel
 order by booking_channel desc;
 
 -- Website	984
--  walk-in	314
--  Travel Agent	405
--  phone	222
--  Mobile App	875


-- 2.Which booking chsnnel is most famous

 select booking_channel, count(booking_id) as channel_bookings
 from bookings
 group by booking_channel
 order by booking_channel desc
 limit 1;


-- Website	984

-- 3.what percentage of bookingd came from each channel

 SELECT
    booking_channel,
    COUNT(booking_id) AS total_bookings,
    ROUND(
        COUNT(booking_id) * 100.0 /
        (SELECT COUNT(*) FROM bookings),
        2
    ) AS booking_percentage
FROM bookings
GROUP BY booking_channel
ORDER BY booking_percentage DESC;
 
 -- 4.Which guest has has a higher total booking amount
 
 SELECT
    guest_id,
    SUM(total_amount) AS total_booking_amount
FROM bookings
GROUP BY guest_id
ORDER BY total_booking_amount DESC
LIMIT 1;

-- G0350:1196045.76

-- 5.individul v/s corporate guests
-- -- -- 5.1 how many bookings was booked by the individual guests

SELECT
    g.guest_type,
    COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
WHERE g.guest_type = 'Individual'
GROUP BY g.guest_type;


-- Individual	1903

-- 5.2 how many bookings was booked by the corporate guests

SELECT
    g.guest_type,
    COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
WHERE g.guest_type = 'corporate'
GROUP BY g.guest_type;

-- Corporate	897


-- 6.how does guest's frequency change over time

SELECT
    YEAR(booking_date) AS booking_year,
    COUNT(booking_id) AS total_bookings,
    COUNT(DISTINCT guest_id) AS unique_guests
FROM bookings
GROUP BY YEAR(booking_date)
ORDER BY booking_year ASC; 


-- 4.3 Evaluate Stay Performance

-- 1.how many stays are completed at each hotel

SELECT
    h.hotel_name,
    COUNT(s.stay_id) AS completed_stays
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status = 'Checked-Out'
GROUP BY h.hotel_name
ORDER BY completed_stays DESC;


-- 2.which hotel has the highest number of cancelled days


SELECT
    h.hotel_name,
    SUM(b.nights_booked) AS total_cancelled_days
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY h.hotel_name
ORDER BY total_cancelled_days DESC
LIMIT 1;


-- StayPoint Mumbai Residency	151

-- 3.Which hotel has the longest avarage stasy duration

SELECT
    h.hotel_name,
    ROUND(AVG(s.stay_duration_hrs), 2) AS avg_stay_duration
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status = 'Checked-Out'
GROUP BY h.hotel_name
ORDER BY avg_stay_duration DESC
LIMIT 1;


-- StayPoint Pune Plaza	91.49

-- 4. How many stays are checked-out

select count(stay_id) from stays as checked_out_stays
where status = "Checked-out";

-- 2117

-- 5. How many bookings are cancelled

select count(stay_id) from stays as cancelled_stays
where status = "Cancelled";

-- 4.4 Understand Staff and Room Performance

-- 1.How many stays does each staff member handled


SELECT
    st.staff_id,
    COUNT(s.stay_id) AS total_stays_handled
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
GROUP BY st.staff_id
ORDER BY total_stays_handled DESC;

-- 2.how many checked-out stays does each staff member handled

SELECT
    st.staff_id,
    COUNT(s.stay_id) AS total_checked_out_stays
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
where s.status = "checked-out"    
GROUP BY st.staff_id
ORDER BY total_checked_out_stays desc;


-- 3. how many stays are cancelled are associated with each staff member

SELECT
    st.staff_id,
    COUNT(s.stay_id) AS total_cancelled_stays
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
where s.status = "cancelled"    
GROUP BY st.staff_id
ORDER BY total_cancelled_stays desc;

-- 4.what is the average stay duration handled by each customer

SELECT
    st.staff_id,
    round(avg(s.stay_duration_hrs),2) AS average_stay_duration
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id   
GROUP BY st.staff_id
ORDER BY  average_stay_duration desc;


-- 5.which room type has the lowest usage

SELECT
    r.room_type,
    COUNT(s.stay_id) AS total_usage
FROM rooms r
LEFT JOIN stays s
    ON r.room_id = s.room_id
GROUP BY r.room_type
ORDER BY total_usage ASC
LIMIT 1;


-- Executive	278

-- 6.how many stays are associated with each room type

SELECT
    r.room_type,
    COUNT(s.stay_id) AS total_stays
FROM rooms r
JOIN stays s
    ON r.room_id = s.room_id
GROUP BY r.room_type
ORDER BY total_stays DESC;


-- Standard	1440
-- Deluxe	1018
-- Suite	464
-- Executive	278

-- which rooms have the highest number of the stays

SELECT
    r.room_id,
    r.room_type,
    COUNT(s.stay_id) AS total_stays
FROM rooms r
JOIN stays s
    ON r.room_id = s.room_id
GROUP BY r.room_id, r.room_type
ORDER BY total_stays DESC
LIMIT 1;


-- R00244	Standard	14



-- 4.5 Identify Booking and Stay Problems

-- How many bookings resulted in cancellations and no-shows

SELECT
    s.status,
    COUNT(DISTINCT b.booking_id) AS total_bookings
FROM bookings b
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled', 'No Show')
GROUP BY s.status
ORDER BY total_bookings DESC;

-- Cancelled	480

-- 2. Which booking channel has the highest number of cancellations and no-shows

SELECT
    b.booking_channel,
    COUNT(DISTINCT b.booking_id) AS problem_bookings
FROM bookings b
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled', 'No Show')
GROUP BY b.booking_channel
ORDER BY problem_bookings DESC;


-- Mobile App	164
-- Website	158
-- Travel Agent	75
-- Walk-in	47
-- Phone	36


--  3. What is the distribution of stays across different statuses

SELECT
    status,
    COUNT(stay_id) AS total_stays,
    ROUND(
        COUNT(stay_id) * 100.0 /
        (SELECT COUNT(*) FROM stays), 2
    ) AS percentage
FROM stays
GROUP BY status
ORDER BY total_stays DESC;


-- Checked-out	2117	66.16
-- No-show	542	16.94
-- Cancelled	480	15.00
-- In-progress	61	1.91

-- 4. Which hotels have the highest number of cancelled and no-show stays


SELECT
    h.hotel_id,
    h.hotel_name,
    s.status,
    COUNT(s.stay_id) AS total_problem_stays
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled', 'No Show')
GROUP BY h.hotel_id, h.hotel_name, s.status
ORDER BY total_problem_stays DESC;

-- 5. How does the number of service requests affect stay duration and stay status

SELECT
    service_requests,
    status,
    COUNT(stay_id) AS total_stays,
    ROUND(AVG(stay_duration_hrs), 2) AS average_stay_duration
FROM stays
GROUP BY service_requests, status
ORDER BY service_requests DESC;


-- 6. Which hotels experience the highest number of booking problems (cancellations and no-shows)

SELECT
    h.hotel_id,
    h.hotel_name,
    COUNT(DISTINCT b.booking_id) AS total_problem_bookings
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
JOIN stays s
    ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled', 'No Show')
GROUP BY
    h.hotel_id,
    h.hotel_name
ORDER BY total_problem_bookings DESC;




select * from stays;


select hotel_id, count(booking_id) as total_bookings 
from bookings group by hotel_id 
having count(booking_id) < 100 ;


select  count(booking_id) as total_bookings from bookings;


select booking_channel, count(booking_id) as total_bookings
from bookings group by booking_channel
order by total_bookings asc;

select * from bookings;


select
    r.room_type,
    COUNT(*) as total_bookings
from bookings b
join stays s
    on b.booking_id = s.booking_id
join rooms r
    on s.room_id = r.room_id
group by r.room_type
order by  total_bookings asc
LIMIT 1;


select * from bookings;
select distinct room_type_requested from bookings;


select
    r.room_type,
    COUNT(*) as total_bookings
from bookings b
join stays s
    on b.booking_id = s.booking_id
join rooms r
    on s.room_id = r.room_id
group by r.room_type
order by  total_bookings asc
LIMIT 1;


select 
      year(booking_date) as booking_year,
      month(booking_date) as booking_month,
      count(booking_id) as total_bookings
from bookings  
group by 
        year(booking_date),   
        month(booking_date)
order by booking_year,booking_month; 


select 
     Dayname(booking_date) as booking_day,
     count(booking_id) as total_bookings
from bookings
group by Dayname(booking_date),
dayofweek(booking_date)
order by total_bookings desc
 ;     

 
 select h.hotel_name,
    SUM(b.total_amount) AS total_booking_amount
FROM hotels h
JOIN bookings b
    ON h.hotel_id = b.hotel_id
GROUP BY h.hotel_name
ORDER BY total_booking_amount DESC
LIMIT 1;

-- StayPoint Mumbai Grand	3773668.50

SELECT
    g.guest_type,
    SUM(b.total_amount) AS total_booking_amount
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type
ORDER BY total_booking_amount DESC;

-- Individual	31394351.96
-- Corporate	14428826.77


SELECT
    g.guest_type,
    ROUND(AVG(b.total_amount), 2) AS average_booking_amount
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type
ORDER BY average_booking_amount DESC
;

-- Individual	16497.29



SELECT
    guest_id,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY guest_id
ORDER BY total_bookings DESC;



SELECT
    guest_id,
    COUNT(booking_id) AS total_bookings
FROM bookings
GROUP BY guest_id
ORDER BY total_bookings DESC
LIMIT 1;




SELECT
    g.guest_type,
    COUNT(b.booking_id) AS total_bookings
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type
ORDER BY total_bookings DESC;


-- Individual	1903
-- Corporate	897


SELECT
    ROUND(COUNT(booking_id) / COUNT(DISTINCT guest_id), 2)
    AS average_bookings_per_guest
FROM bookings;


SELECT
    guest_id,
    sum(booking_id) AS total_bookings
FROM bookings
GROUP BY guest_id
HAVING sum(booking_id) > 3;


SELECT
    COUNT(DISTINCT guest_id) AS unique_guests
FROM bookings;


SELECT
    guest_id,
    COUNT(DISTINCT booking_channel) AS total_channels
FROM bookings
GROUP BY guest_id
HAVING COUNT(DISTINCT booking_channel) > 1;


SELECT
    COUNT(*) AS total_guests
FROM (
    SELECT
        guest_id,
        COUNT(booking_id) AS total_bookings
    FROM bookings
    GROUP BY guest_id
    HAVING COUNT(booking_id) > 5
) AS guest_booking_count;
-- 173


SELECT
    guest_id, 
    max(total_amount) AS total_booking_amount
FROM bookings
GROUP BY guest_id
HAVING max(total_amount) > 50000;



SELECT
    guest_id,
    SUM(total_amount) AS total_booking_amount
FROM bookings
GROUP BY guest_id
ORDER BY total_booking_amount asc
limit 1;

-- G0175	5471.40


-- G0350	1196045.76



SELECT AVG(total_amount)
FROM (
    SELECT SUM(total_amount) AS total_amount
    FROM bookings
    GROUP BY guest_id
) AS guest_spending;

select * from guests where guest_id = "G0175" ;

-- Gwendolyn Klein --> highest booking amount
-- Robert Costa --> lowest booking amount
-- 135171.618673 --> average amount 


SELECT SUM(total_amount) AS total_revenue
FROM bookings;


SELECT h.hotel_id, h.hotel_name,
       COUNT(*) AS total_bookings
FROM bookings b
JOIN hotels h ON b.hotel_id = h.hotel_id
GROUP BY h.hotel_id, h.hotel_name;



SELECT
    AVG(total_bookings) AS average_booking_rate
FROM (
    SELECT hotel_id, COUNT(*) AS total_bookings
    FROM bookings
    GROUP BY hotel_id
) AS hotel_bookings;


SELECT hotel_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY hotel_id
ORDER BY total_bookings DESC
LIMIT 1;

select * from hotels where hotel_id = "H004";

SELECT guest_id, hotel_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY guest_id, hotel_id;


SELECT hotel_id, SUM(total_amount) AS total_revenue
FROM bookings
GROUP BY hotel_id
ORDER BY total_revenue DESC
LIMIT 1;

-- H009	2373589.85 StayPoint Mumbai Plaza

select * from hotels where hotel_id = "H009";

SELECT hotel_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY hotel_id
ORDER BY total_bookings ASC
LIMIT 1;

-- H016	98 StayPoint Indore Retreat

select * from hotels where hotel_id = "H016";



SELECT hotel_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY hotel_id
ORDER BY total_bookings DESC
LIMIT 1;

-- H004	StayPoint Kolkata Residency  129


SELECT hotel_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY hotel_id
ORDER BY total_bookings ASC
LIMIT 1;

-- H016  StayPoint Indore Retreat	98

SELECT hotel_id, SUM(total_amount) AS total_revenue
FROM bookings
GROUP BY hotel_id
ORDER BY total_revenue DESC
LIMIT 1;

-- H009  StayPoint Mumbai Plaza	2373589.85

-- ind vs cor

SELECT guest_type, COUNT(*) AS total_guests
FROM guests
GROUP BY guest_type;

-- Individual	241
-- Corporate	109

SELECT g.guest_type, COUNT(*) AS total_bookings
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.guest_type;

-- rvenue by guest type

SELECT g.guest_type, SUM(b.total_amount) AS total_revenue
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.guest_type;

-- Individual	31394351.96
-- Corporate	14428826.77

-- avg of booking by guest type
SELECT g.guest_type, AVG(b.total_amount) AS avg_amount
FROM bookings b
JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.guest_type;

-- Individual	16497.294777
-- Corporate	16085.648573

-- avg bookings 

SELECT guest_type, AVG(total_bookings) AS avg_bookings
FROM (
    SELECT g.guest_id, g.guest_type, COUNT(b.booking_id) AS total_bookings
    FROM guests g
    LEFT JOIN bookings b ON g.guest_id = b.guest_id
    GROUP BY g.guest_id, g.guest_type
) AS guest_data
GROUP BY guest_type;

-- Individual	7.8963
-- Corporate	8.2294


-- avg booking amount

-- 4. Average Booking Amount
SELECT
    g.guest_type,
    ROUND(AVG(b.total_amount), 2) AS average_amount
FROM guests g
JOIN bookings b
    ON g.guest_id = b.guest_id
GROUP BY g.guest_type;

-- Individual	16497.29
-- Corporate	16085.65

-- preffered room type for each guest type

WITH room_preferences AS (
    SELECT
        g.guest_type,
        b.room_type_requested,
        COUNT(*) AS total_bookings,
        RANK() OVER (
            PARTITION BY g.guest_type
            ORDER BY COUNT(*) DESC
        ) AS room_rank
    FROM guests g
    JOIN bookings b
        ON g.guest_id = b.guest_id
    GROUP BY g.guest_type, b.room_type_requested
)
SELECT
    guest_type,
    room_type_requested,
    total_bookings
FROM room_preferences
WHERE room_rank = 1;


-- Corporate	Standard	424
-- Individual	Standard	835

-- 1. Monthly Booking Trends
SELECT
    YEAR(booking_date) AS booking_year,
    MONTHNAME(booking_date) AS booking_month,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY YEAR(booking_date), MONTH(booking_date), MONTHNAME(booking_date)
ORDER BY booking_year, MONTH(booking_date) asc limit 1 ;

SELECT
    YEAR(booking_date) AS booking_year,
    COUNT(*) AS total_bookings
FROM bookings
GROUP BY YEAR(booking_date)
ORDER BY booking_year;


SELECT
    YEAR(booking_date) AS booking_year,
    MONTHNAME(booking_date) AS booking_month,
    SUM(total_amount) AS total_revenue
FROM bookings
GROUP BY YEAR(booking_date), MONTH(booking_date), MONTHNAME(booking_date)
ORDER BY booking_year, MONTH(booking_date);

-- total stays

SELECT b.hotel_id, COUNT(s.stay_id) AS total_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY b.hotel_id
ORDER BY total_stays DESC;

select * from hotels where hotel_id = "H006";

-- H006	 StayPoint Mumbai Suites 152

-- 2. Completed Stays

SELECT b.hotel_id, COUNT(s.stay_id) AS completed_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Checked-Out'
GROUP BY b.hotel_id
ORDER BY completed_stays DESC;

select * from hotels where hotel_id = "H023";

-- H006	StayPoint Mumbai Suites  98 stays

-- 3. Cancellation Count

SELECT b.hotel_id, COUNT(s.stay_id) AS cancelled_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY b.hotel_id
ORDER BY cancelled_stays DESC;

-- H023  StayPoint Indore Plaza  26
    
    
    -- avarage stay duration 
    
    SELECT ROUND(AVG(stay_duration_hrs), 2) AS avg_duration
FROM stays
WHERE status = 'Checked-Out';

-- 81.03

-- longest stay durations

SELECT stay_id, stay_duration_hrs
FROM stays
WHERE status = 'Checked-Out'
ORDER BY stay_duration_hrs DESC
LIMIT 1;

-- 366

-- average night stayed 

SELECT ROUND(AVG(nights_stayed), 2) AS avg_nights
FROM stays
WHERE status = 'Checked-Out';

-- 3.29

SELECT status, COUNT(*) AS total_stays
FROM stays
GROUP BY status
ORDER BY total_stays DESC;


SELECT
ROUND(SUM(status = 'Checked-Out') * 100.0 / COUNT(*), 2)
AS completion_rate
FROM stays;

-- 66.16

-- Cancellation Rate


SELECT
ROUND(SUM(status = 'Cancelled') * 100.0 / COUNT(*), 2)
AS cancellation_rate
FROM stays;

-- 15.00 cancellation rate


SELECT
ROUND(SUM(status = 'No-Show') * 100.0 / COUNT(*), 2)
AS no_show_rate
FROM stays;

-- 16.94


-- . Total bookings per hotel

SELECT hotel_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY hotel_id;


-- poor outcome ranking

SELECT b.hotel_id,
COUNT(CASE WHEN s.status IN ('Cancelled', 'No Show')
THEN 1 END) AS poor_outcomes
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY b.hotel_id
ORDER BY poor_outcomes DESC;

select * from hotels where hotel_id = "H023";

-- H023  StayPoint Indore Plaza	26


-- hotel revenue highest

SELECT hotel_id, SUM(total_amount) AS total_revenue
FROM bookings
GROUP BY hotel_id
ORDER BY total_revenue DESC limit 1 ;

select * from hotels where hotel_id = "H009";

-- H009	 StayPoint Mumbai Plaza  2373589.85

-- hotel revenue lowest

SELECT hotel_id, SUM(total_amount) AS total_revenue
FROM bookings
GROUP BY hotel_id
ORDER BY total_revenue ASC limit 1 ;

select * from hotels where hotel_id = "H020";

-- H020	 StayPoint Kochi Heights   1392393.71


-- hotel performance ranking 

SELECT b.hotel_id,
COUNT(CASE WHEN s.status = 'Checked-Out' THEN 1 END) AS completed_stays,
RANK() OVER (
ORDER BY COUNT(CASE WHEN s.status = 'Checked-Out' THEN 1 END) DESC
) AS performance_rank
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY b.hotel_id;


-- avg service requested

SELECT b.hotel_id,
AVG(s.service_requests) AS avg_requests
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY b.hotel_id;

-- 1. Monthly stay trends

SELECT YEAR(b.booking_date) AS year,
MONTH(b.booking_date) AS month,
COUNT(s.stay_id) AS total_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY YEAR(b.booking_date), MONTH(b.booking_date)
ORDER BY year, month Asc;

-- 2026	  5	  154


-- 2. Yearly stay trends

SELECT YEAR(b.booking_date) AS year,
COUNT(s.stay_id) AS total_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY YEAR(b.booking_date)
ORDER BY year;

-- 2025	1200



-- Monthly cancellations

SELECT MONTH(b.booking_date) AS month,
COUNT(*) AS cancellations
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY MONTH(b.booking_date)
ORDER BY month;


-- monthly completed stays

SELECT MONTH(b.booking_date) AS month,
COUNT(*) AS completed_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Checked-Out'
GROUP BY MONTH(b.booking_date)
ORDER BY month;


-- 5	219


SELECT YEAR(b.booking_date) AS year,
MONTH(b.booking_date) AS month,
ROUND(SUM(s.status = 'Checked-Out') * 100.0 / COUNT(*), 2) AS completion_rate
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY YEAR(b.booking_date), MONTH(b.booking_date)
ORDER BY year, month;

-- 2024	3	78.79


SELECT b.hotel_id,
COUNT(CASE WHEN s.status = 'Checked-Out' THEN 1 END) AS completed_stays,
RANK() OVER (
ORDER BY COUNT(CASE WHEN s.status = 'Checked-Out' THEN 1 END) DESC
) AS performance_rank
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY b.hotel_id;

select * from hotels where hotel_id = "H006";

-- H006	 StayPoint Mumbai Suites   98	 1


-- 4.4


-- 1. Highest stays

SELECT staff_id, COUNT(*) AS total_stays
FROM stays
GROUP BY staff_id
ORDER BY total_stays DESC
LIMIT 1;

select * from staff where staff_id = "S044";

-- S044  Anthony Humphrey 	59


-- 1. lowest stays

SELECT staff_id, COUNT(*) AS total_stays
FROM stays
GROUP BY staff_id
ORDER BY total_stays asc
LIMIT 1;

select * from staff where staff_id = "S021";


-- S021  Margaret Hawkins DDS	30

-- 5. Staff handling more than 50 stays

SELECT staff_id, COUNT(*) AS total_stays
FROM stays
GROUP BY staff_id
HAVING COUNT(*) > 50;


-- 8. Active staff stays

SELECT st.staff_id, count(s.stay_id) AS total_stays
FROM staff st
JOIN stays s ON st.staff_id = s.staff_id
WHERE st.is_active = 'Yes'
GROUP BY st.staff_id
ORDER BY total_stays DESC;

-- 6. Highest department

SELECT st.department, COUNT(*) AS total_stays
FROM staff st
JOIN stays s ON st.staff_id = s.staff_id
GROUP BY st.department
ORDER BY total_stays DESC
LIMIT 1;

-- Front Desk	980

-- 1. Checked-out stays per staff

SELECT staff_id, COUNT(*) AS completed_stays
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id
ORDER BY completed_stays DESC;

select * from staff where staff_id = "S044";

-- S044	 Anthony Humphrey  44


-- 2. Cancelled stays per staff
SELECT staff_id, COUNT(*) AS cancelled_stays
FROM stays
WHERE status = 'Cancelled'
GROUP BY staff_id
ORDER BY cancelled_stays DESC;

select * from staff where staff_id = "S031";

-- S031  Rebecca Henderson	13


-- 5. Staff with most completed stays
SELECT staff_id, COUNT(*) AS completed_stays
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id
ORDER BY completed_stays DESC
LIMIT 1;

-- 6. Staff with most cancellations
SELECT staff_id, COUNT(*) AS cancelled_stays
FROM stays
WHERE status = 'Cancelled'
GROUP BY staff_id
ORDER BY cancelled_stays DESC
LIMIT 1;

-- 10. Department-wise stay outcomes
SELECT
    st.department,
    s.status,
    count(*) AS total_stays
FROM staff st
JOIN stays s ON st.staff_id = s.staff_id
GROUP BY st.department, s.status
ORDER BY st.department, total_stays DESC;

-- Front Desk	Checked-out	665


SELECT
    st.department,
    COUNT(s.stay_id) AS completed_stays
FROM staff st
JOIN stays s
    ON st.staff_id = s.staff_id
WHERE s.status = 'Checked-Out'
GROUP BY st.department
ORDER BY completed_stays DESC;

-- Front Desk	665
-- Housekeeping	637
-- Concierge	438
-- Guest Services	230
-- Maintenance	147


-- 1. Average duration per staff
SELECT staff_id, ROUND(AVG(stay_duration_hrs), 2) AS avg_duration
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id;



-- 8. Total stay hours
SELECT staff_id, SUM(stay_duration_hrs) AS total_hours
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id;


select * from staff where staff_id = "S001";


-- 2. Highest average duration
SELECT staff_id, ROUND(AVG(stay_duration_hrs), 2) AS avg_duration
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id
ORDER BY avg_duration DESC
LIMIT 1;

select * from staff where staff_id = "S017";

-- S017  


-- 4. Maximum duration
SELECT staff_id, MAX(stay_duration_hrs) AS max_duration
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id  ;


-- 6. Stays exceeding 48 hours
SELECT staff_id, COUNT(*) AS long_stays
FROM stays
WHERE status = 'Checked-Out'
AND stay_duration_hrs > 48
GROUP BY staff_id ;



-- 10. Average duration by department
SELECT
    st.department,
    ROUND(AVG(s.stay_duration_hrs), 2) AS avg_duration
FROM staff st
JOIN stays s ON st.staff_id = s.staff_id
WHERE s.status = 'Checked-Out'
GROUP BY st.department;

-- Front Desk	83.54



-- 8. Total stay hours
SELECT staff_id, SUM(stay_duration_hrs) AS total_hours
FROM stays
WHERE status = 'Checked-Out'
GROUP BY staff_id;



-- 1. Most used room type
SELECT r.room_type, COUNT(*) AS total_stays
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
GROUP BY r.room_type
ORDER BY total_stays DESC
LIMIT 1;

-- Standard	1440

-- 2. Least used room type
SELECT r.room_type, COUNT(*) AS total_stays
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
GROUP BY r.room_type
ORDER BY total_stays ASC
LIMIT 1;

-- Executive	278

-- 6. Revenue by room type
SELECT
    r.room_type,
    SUM(b.total_amount) AS total_revenue
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
JOIN bookings b ON s.booking_id = b.booking_id
GROUP BY r.room_type
ORDER BY total_revenue DESC;

-- Standard	22968510.31


-- 1. Highest room usage
SELECT room_id, COUNT(*) AS total_stays
FROM stays
GROUP BY room_id
ORDER BY total_stays DESC limit  1;

select * from rooms where room_id = "R00244";

-- R00244 	14

-- 2. Lowest room usage (including unused rooms)
SELECT r.room_id, COUNT(s.stay_id) AS total_stays
FROM rooms r
LEFT JOIN stays s ON r.room_id = s.room_id
GROUP BY r.room_id
ORDER BY total_stays ASC
LIMIT 1;

select * from rooms where room_id = "R00350";

-- 3. Stays per room
SELECT room_id, COUNT(*) AS total_stays
FROM stays
GROUP BY room_id
ORDER BY total_stays DESC;


-- R00350	0


-- 4. Highest completed stays
SELECT room_id, COUNT(*) AS completed_stays
FROM stays
WHERE status = 'Checked-Out'
GROUP BY room_id
ORDER BY completed_stays DESC
LIMIT 1;

select * from rooms where room_id = "R00193";

-- R00193	H008	Standard  11

select * from hotels where hotel_id = "H016";

-- StayPoint Goa Grand
-- StayPoint Indore Retreat

-- 4. Highest completed stays
SELECT room_id, COUNT(*) AS completed_stays
FROM stays
WHERE status = 'Checked-Out'
GROUP BY room_id
ORDER BY completed_stays DESC
;

select * from rooms where room_id = "R00193";
select * from hotels where hotel_id = "H016";

-- R00193  StayPoint Indore Retreat  Standard	11


-- 1. Cancelled bookings
SELECT DISTINCT count(booking_id) as cancelled_stays
FROM stays
WHERE status = 'Cancelled';

-- 480

-- 2. No-show bookings

select distinct count(booking_id) as No_show_stays
from stays 
where status = "No-show";

-- 542

-- 5. Cancellation rate
SELECT
    ROUND(SUM(status = 'Cancelled') * 100.0 / COUNT(*), 2)
    AS cancellation_rate
FROM stays;

-- 15.00 %

-- 6. No-show rate
SELECT
    ROUND(SUM(status = 'No-Show') * 100.0 / COUNT(*), 2)
    AS no_show_rate
FROM stays;

-- 16.94% 


-- 7. Cancellations by booking channel
SELECT
    b.booking_channel,
    COUNT(DISTINCT b.booking_id) AS cancelled_bookings
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY b.booking_channel
ORDER BY cancelled_bookings DESC;


-- Mobile App	164
-- Website	158
-- Travel Agent	75
-- Walk-in	47
-- Phone	36

-- 8. No-shows by booking channel
SELECT
    b.booking_channel,
    COUNT(DISTINCT b.booking_id) AS no_show_bookings
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'No-Show'
GROUP BY b.booking_channel
ORDER BY no_show_bookings DESC;

-- Mobile App	174
-- Website	171
-- Travel Agent	69
-- Walk-in	57
-- Phone	40

-- 9. Total cancelled booking amount
SELECT SUM(b.total_amount) AS cancelled_amount
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled';

-- 7766150.98

-- 10. Total no-show booking amount
SELECT SUM(b.total_amount) AS no_show_amount
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'No-Show';

-- 9139962.38


-- 1. Most common status
SELECT status, COUNT(*) AS total_stays
FROM stays
GROUP BY status
ORDER BY total_stays DESC
LIMIT 1;

-- Checked-out	2117

-- 2. Least common status
SELECT status, COUNT(*) AS total_stays
FROM stays
GROUP BY status
ORDER BY total_stays ASC
LIMIT 1;

-- In-progress	61

-- 3. Stay count by status
SELECT status, COUNT(*) AS total_stays
FROM stays
GROUP BY status;

-- Checked-out	2117
-- In-progress	61
-- No-show	542
-- Cancelled	480


-- 4. Status percentage
SELECT
    status,
    ROUND(COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM stays), 2) AS status_percentage
FROM stays
GROUP BY status;

-- Checked-out	66.16
-- In-progress	1.91
-- No-show	16.94
-- Cancelled	15.00

-- 5. Booking channel with most problem stays
SELECT
    b.booking_channel,
    COUNT(DISTINCT b.booking_id) AS problem_bookings
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled', 'No-Show')
GROUP BY b.booking_channel
ORDER BY problem_bookings DESC
LIMIT 1;

-- Mobile App	319

-- 7. Room type with most cancellations
SELECT
    r.room_type,
    COUNT(*) AS cancelled_stays
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
WHERE s.status = 'Cancelled'
GROUP BY r.room_type
ORDER BY cancelled_stays DESC
LIMIT 1;

-- Standard	227


-- 9. Cancellations by guest type
SELECT
    g.guest_type,
    COUNT(DISTINCT b.booking_id) AS cancelled_bookings
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY g.guest_type
ORDER BY cancelled_bookings DESC;

-- 10. Average booking amount by status
SELECT
    s.status,
    ROUND(AVG(b.total_amount), 2) AS avg_booking_amount
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY s.status;

-- average booking amount 
-- Checked-out	16196.78
-- In-progress	18018.52
-- No-show	    16863.40
-- Cancelled	16179.48



-- 1. Stays with highest service requests
SELECT stay_id, service_requests
FROM stays
ORDER BY service_requests DESC
LIMIT 10;

-- 2. Stays with more than 5 requests
SELECT COUNT(*) AS high_request_stays
FROM stays
WHERE service_requests > 5;

select * from stays;

-- 0

-- 3. Status with most service requests
SELECT status, SUM(service_requests) AS total_requests
FROM stays
GROUP BY status
ORDER BY total_requests DESC
;

-- Checked-out	2295

-- 4. Average requests by status
SELECT
    status,
    ROUND(AVG(service_requests), 2) AS avg_requests
FROM stays
GROUP BY status;

-- Checked-out	1.08
-- In-progress	0.62
-- No-show	0.00
-- Cancelled	0.00

-- 5. High-request completed stays
SELECT COUNT(*) AS completed_stays
FROM stays
WHERE service_requests > 5
AND status = 'Checked-Out';

-- 6. High-request problem stays
SELECT status, COUNT(*) AS problem_stays
FROM stays
WHERE service_requests > 5
AND status IN ('Cancelled', 'No-Show')
GROUP BY status;

-- 7. Requests by room type
SELECT
    r.room_type,
    SUM(s.service_requests) AS total_requests
FROM rooms r
JOIN stays s ON r.room_id = s.room_id
GROUP BY r.room_type
ORDER BY total_requests DESC;

-- Standard	    1027
-- Deluxe	    720
-- Suite	    388
-- Executive	198

-- 8. High-request stays by booking channel
SELECT
    b.booking_channel,
    COUNT(*) AS high_request_stays
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.service_requests > 5
GROUP BY b.booking_channel
ORDER BY high_request_stays DESC;

select * from stays;

-- 9. Average duration of high-request stays
SELECT
    ROUND(AVG(stay_duration_hrs), 2) AS avg_duration_hrs
FROM stays
WHERE service_requests > 5
AND status = 'Checked-Out';

select * from stays;

-- 10. High-request bookings not completed
SELECT
    b.booking_id,
    s.status,
    s.service_requests
FROM bookings b
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.service_requests > 5
AND s.status IN ('Cancelled', 'No-Show', 'In-Progress');


SELECT
    stay_id,
    service_requests
FROM stays
ORDER BY service_requests DESC
LIMIT 1;

-- 4.4 ---------------------------------------------------------------------------------

-- 1. Hotel with most cancellations
SELECT
    h.hotel_id,
    COUNT(*) AS cancelled_stays
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY h.hotel_id
ORDER BY cancelled_stays DESC
LIMIT 1;


-- H023	 StayPoint Indore Plaza 26

-- 2. Hotel with most no-shows
SELECT
    h.hotel_id,
    COUNT(*) AS no_show_stays
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'No-Show'
GROUP BY h.hotel_id
ORDER BY no_show_stays DESC
LIMIT 1;

select * from hotels where hotel_id  = "H006";
-- H006	StayPoint Mumbai Suites  31

-- 3. Problem stays by hotel
SELECT
    h.hotel_id,
    COUNT(*) AS problem_stays
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status IN ('Cancelled', 'No-Show')
GROUP BY h.hotel_id
ORDER BY problem_stays DESC;

select * from hotels where hotel_id  = "H023";
-- H023	53

-- 4. Cancellation rate by hotel
SELECT
    h.hotel_id,
    ROUND(
        SUM(s.status = 'Cancelled') * 100.0 / COUNT(*), 2
    ) AS cancellation_rate
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id;

-- 5. No-show rate by hotel
SELECT
    h.hotel_id,
    ROUND(
        SUM(s.status = 'No-Show') * 100.0 / COUNT(*), 2
    ) AS no_show_rate
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id;

-- 6. Hotel with highest problem rate
SELECT
    h.hotel_id,
    ROUND(
        SUM(s.status IN ('Cancelled', 'No-Show')) * 100.0
        / COUNT(*), 2
    ) AS problem_rate
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id
ORDER BY problem_rate DESC
LIMIT 1;

-- H017	StayPoint Kochi Palace 39.20


-- 7. Stay statuses by hotel
SELECT
    h.hotel_id,
    s.status,
    COUNT(*) AS total_stays
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id, s.status
ORDER BY h.hotel_id, total_stays DESC;

-- 8. Service requests by hotel
SELECT
    h.hotel_id,
    SUM(s.service_requests) AS total_requests
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id
ORDER BY total_requests DESC;

-- H006 StayPoint Mumbai Suites	115

-- 9. Cancelled booking amount by hotel
SELECT
    h.hotel_id,
    SUM(b.total_amount) AS cancelled_amount
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Cancelled'
GROUP BY h.hotel_id
ORDER BY cancelled_amount DESC;

-- 10. Completed stays by hotel
SELECT
    h.hotel_id,
    COUNT(*) AS completed_stays
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
WHERE s.status = 'Checked Out'
GROUP BY h.hotel_id
ORDER BY completed_stays DESC;


-- highest cancellation rate hotel
SELECT
    h.hotel_id,
    ROUND(
        SUM(s.status = 'Cancelled') * 100.0 / COUNT(*), 2
    ) AS cancellation_rate
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id
ORDER BY cancellation_rate DESC
LIMIT 1;

select * from hotels where hotel_id = "H013";
-- H013	StayPoint Ahmedabad Plaza  19.17

-- highest no show rqate

SELECT
    h.hotel_id,
    ROUND(
        SUM(s.status = 'No-Show') * 100.0 / COUNT(*), 2
    ) AS no_show_rate
FROM hotels h
JOIN bookings b ON h.hotel_id = b.hotel_id
JOIN stays s ON b.booking_id = s.booking_id
GROUP BY h.hotel_id
ORDER BY no_show_rate DESC
LIMIT 1; 
 
 select * from hotels where hotel_id = "H017";
 -- H017  StayPoint Kochi Palace	21.60

