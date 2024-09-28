ALTER TABLE `shd_host` ADD COLUMN `upstream_configoption` TEXT COMMENT "上游配置：比如v10,json格式";
ALTER TABLE `shd_renew_cycle` ADD COLUMN `duration` INT(11) NOT NULL DEFAULT 0 COMMENT "v10周期：多少秒";
ALTER TABLE `shd_products` ADD COLUMN `upstream_price` DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT "v10价格";
ALTER TABLE `shd_products` ADD COLUMN `upstream_cycle` VARCHAR(25) NOT NULL DEFAULT "" COMMENT "v10周期";