SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema burstpool
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema burstpool
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `burstpool` DEFAULT CHARACTER SET utf8 ;
USE `burstpool` ;

-- -----------------------------------------------------
-- Table `burstpool`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `burstpool`.`account` (
  `id` BIGINT(20) unsigned NOT NULL,
  `address` VARCHAR(20) NOT NULL,
  `name` VARCHAR(100),
  `pending` BIGINT(20) NOT NULL DEFAULT 0,
  `min_payout_value` BIGINT(20),
  `payout_interval` VARCHAR(20),
  `next_payout_date` DATETIME,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `address_UNIQUE` (`address` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `burstpool`.`nonce_submission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `burstpool`.`nonce_submission` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `miner_id` BIGINT(20) unsigned NOT NULL,
  `block_height` BIGINT(20) unsigned NOT NULL,
  `deadline` BIGINT(20) unsigned NOT NULL,
  `nonce` BIGINT(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `block_miner_UNIQUE` (`block_height` ASC, `miner_id` ASC),
  INDEX `miner_fk_idx` (`miner_id` ASC),
  CONSTRAINT `miner_fk`
    FOREIGN KEY (`miner_id`)
    REFERENCES `burstpool`.`account` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `miner_block_fk`
    FOREIGN KEY (`block_height`)
    REFERENCES `burstpool`.`block` (`height`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `burstpool`.`block`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `burstpool`.`block` (
  `height` BIGINT(20) unsigned NOT NULL,
  `base_target` BIGINT(20) unsigned NOT NULL,
  `scoop` INT unsigned NOT NULL,
  `generation_signature` VARCHAR(64) NOT NULL,
  `winner_verified` TINYINT NOT NULL DEFAULT 0,
  `reward` BIGINT(20) NULL,
  `winner_id` BIGINT(20) unsigned NULL,
  `best_nonce_submission_id` BIGINT(20) NULL,
  `created` DATETIME NOT NULL,
  `generation_time` INT NOT NULL DEFAULT 240,
  PRIMARY KEY (`height`),
  INDEX `winner_account_fk_idx` (`winner_id` ASC),
  INDEX `nonce_submission_fk_idx` (`best_nonce_submission_id` ASC),
  CONSTRAINT `winner_account_fk`
    FOREIGN KEY (`winner_id`)
    REFERENCES `burstpool`.`account` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `nonce_submission_fk`
    FOREIGN KEY (`best_nonce_submission_id`)
    REFERENCES `burstpool`.`nonce_submission` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `burstpool`.`miner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `burstpool`.`miner` (
  `id` BIGINT(20) unsigned NOT NULL,
  `capacity` BIGINT(20) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `miner_account_fk`
    FOREIGN KEY (`id`)
    REFERENCES `burstpool`.`account` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `burstpool`.`transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `burstpool`.`transaction` (
  `id` BIGINT(20) unsigned NOT NULL,
  `amount` BIGINT(20) NOT NULL,
  `recipient_id` BIGINT(20) unsigned NOT NULL,
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `account_fk_idx` (`recipient_id` ASC),
  CONSTRAINT `account_fk`
    FOREIGN KEY (`recipient_id`)
    REFERENCES `burstpool`.`account` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
