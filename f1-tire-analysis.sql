DROP DATABASE f1_tyre_analysis;
CREATE DATABASE f1_tyre_analysis;
USE f1_tyre_analysis;

-- CRIAÇÃO DAS TABELAS 
CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(50) NOT NULL,
    engine_supplier VARCHAR(30),
    aero_efficiency DECIMAL(5,2) COMMENT 'Eficiência aerodinâmica (0-100%)'
);

CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_name VARCHAR(50) NOT NULL,
    team_id INT,
    driving_style ENUM('Agressivo', 'Conservador', 'Balanceado'),
    nationality VARCHAR(30),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);
---------------------------------------------------------------------------------------------
ALTER TABLE Drivers 
MODIFY COLUMN driving_style ENUM('Agressive', 'Balanced', 'Precise', 'Moderate');

ALTER TABLE Drivers 
ADD COLUMN tyre_management_skill TINYINT UNSIGNED 
AFTER driving_style;

UPDATE Drivers 
SET tyre_management_skill = 
  CASE driving_style
    WHEN 'Agressive' THEN 4
    WHEN 'Moderate' THEN 6
    WHEN 'Balanced' THEN 7
    WHEN 'Precise' THEN 9
    ELSE 5
  END
WHERE driver_id > 0; 
---------------------------------------------------------------------------------------------

CREATE TABLE Circuits (
    circuit_id INT PRIMARY KEY AUTO_INCREMENT,
    circuit_name VARCHAR(50) NOT NULL,
    country VARCHAR(30),
    track_type ENUM('Street', 'High-speed', 'Technical'),
    laps INT,
    distance_km DECIMAL(5,3),
    abrasiveness DECIMAL(3,1) COMMENT 'Índice de abrasividade (1-5)'
);

CREATE TABLE Weather (
    weather_id INT PRIMARY KEY AUTO_INCREMENT,
    condition_type ENUM('Sunny', 'Rainy', 'Overcast', 'Damp'),
    temperature_celsius DECIMAL(5,2),
    humidity_percent DECIMAL(5,2)
);
--------------------------------------------------------------------------------------------
ALTER TABLE Weather 
ADD COLUMN track_temp DECIMAL(5,2) AFTER humidity_percent,
ADD COLUMN wind_speed_kmh DECIMAL(5,2) AFTER track_temp;
--------------------------------------------------------------------------------------------

CREATE TABLE TireCompounds (
    compound_id INT PRIMARY KEY AUTO_INCREMENT,
    compound_name VARCHAR(10) NOT NULL,
    expected_laps INT,
    degradation_rate DECIMAL(5,2),
    grip_level ENUM('High', 'Medium', 'Low')
);
--------------------------------------------------------------------------------------------
ALTER TABLE TireCompounds 
ADD COLUMN color_code VARCHAR(7) 
AFTER grip_level;

ALTER TABLE TireCompounds 
MODIFY COLUMN compound_name VARCHAR(20) NOT NULL;

ALTER TABLE TireCompounds 
MODIFY COLUMN grip_level ENUM(
    'Very High',
    'High',
    'Medium',
    'Low',
    'Very Low',
    'Variable'  -- Novo valor para pneus de chuva
);
--------------------------------------------------------------------------------------------

CREATE TABLE Races (
    race_id INT PRIMARY KEY AUTO_INCREMENT,
    circuit_id INT,
    weather_id INT,
    race_date DATE,
    FOREIGN KEY (circuit_id) REFERENCES Circuits(circuit_id),
    FOREIGN KEY (weather_id) REFERENCES Weather(weather_id)
);

CREATE TABLE LapData (
    lap_id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT,
    driver_id INT,
    compound_id INT,
    lap_number INT,
    lap_time_seconds DECIMAL(8,3),
    tyre_wear_percentage DECIMAL(5,2),
    track_temp DECIMAL(5,2),
    position INT,
    FOREIGN KEY (race_id) REFERENCES Races(race_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (compound_id) REFERENCES TireCompounds(compound_id)
);

-------------------------------------------------------------------
-- INSERÇÃO DE DADOS
INSERT INTO Teams (team_name, engine_supplier, aero_efficiency) VALUES
('Red Bull Racing', 'Honda RBPT', 97.5),
('Ferrari', 'Ferrari', 96.8),
('Mercedes', 'Mercedes', 96.3),
('McLaren', 'Mercedes', 95.9),
('Aston Martin', 'Honda RBPT', 95.2),
('Alpine', 'Renault', 94.5),
('Williams', 'Mercedes', 93.8),
('Visa Cash App RB', 'Honda RBPT', 93.5),
('Stake F1 Team', 'Ferrari', 93.0),
('Haas', 'Ferrari', 92.3);

INSERT INTO Circuits (circuit_name, country, track_type, laps, distance_km, abrasiveness) VALUES
-- Circuitos urbanos (alto desgaste)
('Bahrain International Circuit', 'Bahrain', 'Technical', 57, 5.412, 3.9),
('Jeddah Corniche Circuit', 'Saudi Arabia', 'Street', 50, 6.174, 4.2),
('Albert Park Circuit', 'Australia', 'Street', 58, 5.278, 3.5),
('Baku City Circuit', 'Azerbaijan', 'Street', 51, 6.003, 4.3),
('Miami International Autodrome', 'USA', 'Street', 57, 5.412, 3.8),
('Circuit de Monaco', 'Monaco', 'Street', 78, 3.337, 4.7), 
('Las Vegas Strip Circuit', 'USA', 'Street', 50, 6.120, 4.1),

-- Circuitos de alta velocidade
('Silverstone Circuit', 'UK', 'High-speed', 52, 5.891, 3.1),
('Circuit de Spa-Francorchamps', 'Belgium', 'High-speed', 44, 7.004, 3.3),
('Autodromo Nazionale Monza', 'Italy', 'High-speed', 53, 5.793, 2.9), 
('Circuit of The Americas', 'USA', 'High-speed', 56, 5.513, 3.4),

-- Circuitos técnicos
('Suzuka Circuit', 'Japan', 'Technical', 53, 5.807, 3.8),
('Hungaroring', 'Hungary', 'Technical', 70, 4.381, 3.7),
('Marina Bay Street Circuit', 'Singapore', 'Technical', 62, 5.063, 4.5),
('Autódromo Hermanos Rodríguez', 'Mexico', 'Technical', 71, 4.304, 3.6),
('Interlagos Circuit', 'Brazil', 'Technical', 71, 4.309, 3.9),
('Yas Marina Circuit', 'UAE', 'Technical', 55, 5.281, 3.2),
('Shanghai International Circuit', 'China', 'Technical', 56, 5.451, 3.5),
('Circuit Gilles Villeneuve', 'Canada', 'Technical', 70, 4.361, 3.6),
('Red Bull Ring', 'Austria', 'Technical', 71, 4.318, 3.4),
('Zandvoort Circuit', 'Netherlands', 'Technical', 72, 4.259, 3.8),
('Losail International Circuit', 'Qatar', 'Technical', 57, 5.419, 4.0); 

INSERT INTO Weather 
(condition_type, temperature_celsius, humidity_percent, track_temp, wind_speed_kmh) 
VALUES
('Sunny', 28.5, 45.0, 42.3, 10.5),
('Extreme Heat', 38.2, 30.1, 52.0, 8.2),  
('Rainy', 15.5, 94.0, 16.8, 25.7),
('Damp', 20.5, 75.0, 23.1, 12.3),
('Overcast', 19.0, 70.0, 21.5, 15.0);

INSERT INTO Drivers (driver_name, team_id, driving_style, nationality, tyre_management_skill) VALUES
-- Red Bull Racing (team_id = 1)
('Max Verstappen', 1, 'Agressive', 'Dutch', 7),  
('Yuki Tsunoda', 1, 'Agressive', 'Mexican', 4),   
-- Ferrari (team_id = 2)
('Charles Leclerc', 2, 'Agressive', 'Monegasque', 5),
('Lewis Hamilton', 2, 'Balanced', 'British', 9), 
-- Mercedes (team_id = 3)
('George Russell', 3, 'Balanced', 'British', 8),
('Andrea Kimi Antonelli', 3, 'Agressive', 'Italian', 6), 
-- McLaren (team_id = 4)
('Lando Norris', 4, 'Agressive', 'British', 7),   
('Oscar Piastri', 4, 'Precise', 'Australian', 7), 
-- Aston Martin (team_id = 5)
('Fernando Alonso', 5, 'Balanced', 'Spanish', 9), 
('Lance Stroll', 5, 'Moderate', 'Canadian', 5),
-- Alpine (team_id = 6)
('Pierre Gasly', 6, 'Balanced', 'French', 7),
('Jack Doohan', 6, 'Precise', 'Australian', 6),  
-- Williams (team_id = 7)
('Alexander Albon', 7, 'Agressive', 'Thai', 6),
('Carlos Sainz', 7, 'Moderate', 'Spanish', 7), 
-- Visa Cash App RB (team_id = 8)
('Isack Hadjar', 8, 'Agressive', 'French', 4),
('Liam Lawson', 8, 'Balanced', 'New Zealander', 6),
-- Stake F1 Team Kick Sauber (team_id = 9)
('Nico Hülkenberg', 9, 'Balanced', 'German', 6),
('Gabriel Bortoleto', 9, 'Precise', 'Brazilian', 6),
-- Haas (team_id = 10)
('Esteban Ocon', 10, 'Balanced', 'French', 6),
('Oliver Bearman', 10, 'Agressive', 'British', 5);  

INSERT INTO TireCompounds 
(compound_id, compound_name, expected_laps, degradation_rate, grip_level, color_code) 
VALUES
(1, 'C4 (Soft)', 18, 1.8, 'High', '#FF3333'),
(2, 'C3 (Medium)', 28, 1.2, 'Medium', '#FFFF00'),
(3, 'C2 (Hard)', 38, 0.8, 'Low', '#FFFFFF'),
(4, 'Intermediate', 25, 1.5, 'Variable', '#00FF00'),
(5, 'Wet', 30, 1.0, 'Low', '#0000FF');             




