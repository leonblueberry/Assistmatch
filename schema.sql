-- Users table: Stores both companies and gig workers
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) CHECK (role IN ('worker', 'company')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Jobs table: Stores the one-time gigs posted by companies
CREATE TABLE job_posts (
    job_id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES users(user_id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    city VARCHAR(50) NOT NULL,
    industry VARCHAR(50),
    wage_rate DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Availability table: Tracks when workers are free (Crucial for Matching Logic)
CREATE TABLE worker_availability (
    availability_id SERIAL PRIMARY KEY,
    worker_id INTEGER REFERENCES users(user_id),
    day_of_week VARCHAR(15), -- e.g., 'Monday'
    start_time TIME,
    end_time TIME
);

-- Applications table: Connects workers to job posts
CREATE TABLE applications (
    application_id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES job_posts(job_id),
    worker_id INTEGER REFERENCES users(user_id),
    status VARCHAR(20) DEFAULT 'applied', -- applied, interviewing, accepted, rejected
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
