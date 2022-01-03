-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 03, 2022 at 11:39 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `annotationsdatabase`
--

-- --------------------------------------------------------

--
-- Table structure for table `annotations`
--

CREATE TABLE `annotations` (
  `ID` int(100) NOT NULL,
  `topValue` int(100) NOT NULL,
  `leftValue` int(100) NOT NULL,
  `width` int(100) NOT NULL,
  `height` int(100) NOT NULL,
  `class_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `annotations`
--

INSERT INTO `annotations` (`ID`, `topValue`, `leftValue`, `width`, `height`, `class_id`) VALUES
(0, 171, 1033, 190, 172, 'Cat'),
(1, 266, 930, 228, 209, 'Dog'),
(2, 171, 1033, 190, 172, 'Cat'),
(3, 206, 1084, 158, 213, 'Orange'),
(4, 154, 1242, 143, 159, 'Apple'),
(5, 143, 1152, 85, 61, 'Cherry'),
(6, 206, 1084, 158, 213, 'Orange'),
(7, 154, 1242, 143, 159, 'Apple'),
(8, 143, 1152, 85, 61, 'Cherry');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `annotations`
--
ALTER TABLE `annotations`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `annotations`
--
ALTER TABLE `annotations`
  MODIFY `ID` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
