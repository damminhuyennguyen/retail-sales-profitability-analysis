-- retail_supply_chain.dim_calendar definition

CREATE TABLE `dim_calendar` (
  `cal_date` date DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `quarter` int(11) DEFAULT NULL,
  `quater_label` varchar(50) DEFAULT NULL,
  `quarter_year` varchar(50) DEFAULT NULL,
  `month_number` int(11) DEFAULT NULL,
  `month_name` varchar(50) DEFAULT NULL,
  `month_year` date DEFAULT NULL,
  `week_of_year` int(11) DEFAULT NULL,
  `week_label` varchar(50) DEFAULT NULL,
  `day_of_week` int(11) DEFAULT NULL,
  `day_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- retail_supply_chain.dim_product definition

CREATE TABLE `dim_product` (
  `product_id` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `sub_category` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_key` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- retail_supply_chain.dim_customer definition

CREATE TABLE `dim_customer` (
  `customer_id` varchar(50) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `segment` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- retail_supply_chain.fact_order_lines definition

CREATE TABLE `fact_order_lines` (
  `row_id` int(11) DEFAULT NULL,
  `order_id` varchar(50) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `ship_date` date DEFAULT NULL,
  `ship_mode` varchar(50) DEFAULT NULL,
  `customer_id` varchar(50) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `segment` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `city` varchar(128) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `region` varchar(50) DEFAULT NULL,
  `retail_sales_person` varchar(128) DEFAULT NULL,
  `product_id` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `sub_category` varchar(50) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `returned` varchar(10) DEFAULT NULL,
  `sales` decimal(14,4) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `discount` decimal(5,4) DEFAULT NULL,
  `profit` decimal(14,4) DEFAULT NULL,
  `ship_days` int(11) DEFAULT NULL,
  `returned_flag` tinyint(4) DEFAULT NULL,
  `ship_days_over_30_flag` tinyint(4) DEFAULT NULL,
  `product_key` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;