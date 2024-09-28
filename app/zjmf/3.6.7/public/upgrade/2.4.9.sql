ALTER TABLE `shd_product_config_options` ADD `is_rebate` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否折扣';
UPDATE `shd_plugin` SET `help_url`='https://my.idcsmart.com/shop/shop_detail.html?id=454' WHERE `name`='Idcsmart' AND `module`='sms';
ALTER TABLE `shd_menus` ADD COLUMN `sort` INT(1) NOT NULL DEFAULT '0' COMMENT '排序';