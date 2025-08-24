-- Create sample tables for learning Grafana
CREATE TABLE if NOT exists users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE if NOT exists  orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    product_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE if NOT exists page_views (
    id SERIAL PRIMARY KEY,
    page_name VARCHAR(100) NOT NULL,
    user_id INTEGER REFERENCES users(id),
    view_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_duration INTEGER -- in seconds
);

-- Insert sample data
INSERT INTO users (username, email, last_login) VALUES
('john_doe', 'john@example.com', '2024-01-15 10:30:00'),
('jane_smith', 'jane@example.com', '2024-01-15 14:20:00'),
('bob_wilson', 'bob@example.com', '2024-01-14 16:45:00'),
('alice_brown', 'alice@example.com', '2024-01-15 09:15:00'),
('charlie_davis', 'charlie@example.com', '2024-01-13 11:30:00');

INSERT INTO orders (user_id, product_name, amount, status) VALUES
(1, 'Laptop', 999.99, 'completed'),
(1, 'Mouse', 29.99, 'completed'),
(2, 'Keyboard', 89.99, 'pending'),
(3, 'Monitor', 299.99, 'completed'),
(4, 'Headphones', 149.99, 'shipped'),
(5, 'Webcam', 79.99, 'completed');

INSERT INTO page_views (page_name, user_id, session_duration) VALUES
('home', 1, 120),
('products', 1, 300),
('cart', 1, 60),
('home', 2, 180),
('about', 2, 240),
('products', 3, 420),
('contact', 4, 90),
('home', 5, 150);

-- Create a view for analytics
CREATE VIEW user_analytics AS
SELECT 
    u.username,
    COUNT(o.id) as total_orders,
    SUM(o.amount) as total_spent,
    COUNT(pv.id) as total_page_views,
    AVG(pv.session_duration) as avg_session_duration
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN page_views pv ON u.id = pv.user_id
GROUP BY u.id, u.username;