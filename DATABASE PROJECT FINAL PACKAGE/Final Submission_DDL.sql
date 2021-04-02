-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`HEALTHCARE FACILITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`HEALTHCARE FACILITY` (
  `facility_id` INT NOT NULL,
  `facility_name` VARCHAR(45) NOT NULL,
  `facility_zip` VARCHAR(5) NOT NULL,
  `facility_city` VARCHAR(45) NOT NULL,
  `facility_state` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`facility_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PATIENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PATIENT` (
  `patient_id` INT NOT NULL,
  `patient_First_name` VARCHAR(45) NOT NULL,
  `patient_Last_name` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(45) NOT NULL,
  `DOB` VARCHAR(255) NOT NULL,
  `patient_zip` VARCHAR(5) NOT NULL,
  `patient_city` VARCHAR(45) NOT NULL,
  `patient_state` VARCHAR(45) NOT NULL,
  `facility_id` INT NULL,
  `phone_number` VARCHAR(20) NULL,
  `emergency_contact_number` VARCHAR(20) NULL,
  PRIMARY KEY (`patient_id`),
  INDEX `facility_id_idx` (`facility_id` ASC) ,
  CONSTRAINT `facility_id`
    FOREIGN KEY (`facility_id`)
    REFERENCES `mydb`.`HEALTHCARE FACILITY` (`facility_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PHYSICIAN`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PHYSICIAN` (
  `physician_id` INT NOT NULL,
  `physician_First_name` VARCHAR(45) NOT NULL,
  `physician_Last_name` VARCHAR(45) NOT NULL,
  `speciality` VARCHAR(45) NOT NULL,
  `join_date` DATETIME NOT NULL,
  `years_of_experience` VARCHAR(45) NOT NULL,
  `HEALTHCARE FACILITY_facility_id` INT NOT NULL,
  PRIMARY KEY (`physician_id`),
  INDEX `fk_PHYSICIAN_HEALTHCARE FACILITY1_idx` (`HEALTHCARE FACILITY_facility_id` ASC) ,
  CONSTRAINT `fk_PHYSICIAN_HEALTHCARE FACILITY1`
    FOREIGN KEY (`HEALTHCARE FACILITY_facility_id`)
    REFERENCES `mydb`.`HEALTHCARE FACILITY` (`facility_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`APPOINTMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`APPOINTMENT` (
  `appointment_id` INT NULL,
  `PHYSICIAN_physician_id` INT NOT NULL,
  `PATIENT_patient_id` INT NOT NULL,
  `appointment_date` DATETIME NOT NULL,
  `appointment_type` VARCHAR(45) NOT NULL,
  `visit_summary` VARCHAR(45) NULL,
  PRIMARY KEY (`appointment_id`),
  INDEX `fk_APPOINTMENT_PHYSICIAN1_idx` (`PHYSICIAN_physician_id` ASC) ,
  INDEX `fk_APPOINTMENT_PATIENT1_idx` (`PATIENT_patient_id` ASC) ,
  CONSTRAINT `fk_APPOINTMENT_PHYSICIAN1`
    FOREIGN KEY (`PHYSICIAN_physician_id`)
    REFERENCES `mydb`.`PHYSICIAN` (`physician_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_APPOINTMENT_PATIENT1`
    FOREIGN KEY (`PATIENT_patient_id`)
    REFERENCES `mydb`.`PATIENT` (`patient_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TEST_ORDER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TEST_ORDER` (
  `test_order_id` INT NOT NULL,
  `PHYSICIAN_physician_id` INT NOT NULL,
  `patient_id` INT NOT NULL,
  `test_name` VARCHAR(255) NULL,
  PRIMARY KEY (`test_order_id`),
  INDEX `fk_TEST_ORDER_PHYSICIAN1_idx` (`PHYSICIAN_physician_id` ASC) ,
  CONSTRAINT `fk_TEST_ORDER_PHYSICIAN1`
    FOREIGN KEY (`PHYSICIAN_physician_id`)
    REFERENCES `mydb`.`PHYSICIAN` (`physician_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DIAGNOSIS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DIAGNOSIS` (
  `diagnosis_id` INT NOT NULL,
  `diagnosis_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`diagnosis_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SCREENING_TEST`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SCREENING_TEST` (
  `screening_test_id` INT NULL,
  `test_type` VARCHAR(45) NOT NULL,
  `DIAGNOSIS_diagnosis_id` INT NOT NULL,
  `TEST_ORDER_test_order_id` INT NOT NULL,
  `APPOINTMENT_appointment_id1` INT NOT NULL,
  `test_date` DATETIME NULL,
  INDEX `fk_Screening_Test_DIAGNOSIS1_idx` (`DIAGNOSIS_diagnosis_id` ASC) ,
  PRIMARY KEY (`screening_test_id`),
  INDEX `fk_SCREENING_TEST_TEST_ORDER1_idx` (`TEST_ORDER_test_order_id` ASC) ,
  INDEX `fk_SCREENING_TEST_APPOINTMENT1_idx` (`APPOINTMENT_appointment_id1` ASC) ,
  CONSTRAINT `fk_Screening_Test_DIAGNOSIS1`
    FOREIGN KEY (`DIAGNOSIS_diagnosis_id`)
    REFERENCES `mydb`.`DIAGNOSIS` (`diagnosis_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_SCREENING_TEST_TEST_ORDER1`
    FOREIGN KEY (`TEST_ORDER_test_order_id`)
    REFERENCES `mydb`.`TEST_ORDER` (`test_order_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_SCREENING_TEST_APPOINTMENT1`
    FOREIGN KEY (`APPOINTMENT_appointment_id1`)
    REFERENCES `mydb`.`APPOINTMENT` (`appointment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DIAGNOSIS_RECORD`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DIAGNOSIS_RECORD` (
  `PHYSICIAN_physician_id` INT NOT NULL,
  `DIAGNOSIS_diagnosis_id` INT NOT NULL,
  `screening_test` VARCHAR(45) NOT NULL,
  `PATIENT_patient_id` INT NOT NULL,
  PRIMARY KEY (`PHYSICIAN_physician_id`, `DIAGNOSIS_diagnosis_id`, `PATIENT_patient_id`),
  INDEX `fk_PHYSICIAN_has_DIAGNOSIS_DIAGNOSIS1_idx` (`DIAGNOSIS_diagnosis_id` ASC) ,
  INDEX `fk_PHYSICIAN_has_DIAGNOSIS_PHYSICIAN1_idx` (`PHYSICIAN_physician_id` ASC) ,
  INDEX `fk_DIAGNOSIS_RECORD_PATIENT1_idx` (`PATIENT_patient_id` ASC) ,
  CONSTRAINT `fk_PHYSICIAN_has_DIAGNOSIS_PHYSICIAN1`
    FOREIGN KEY (`PHYSICIAN_physician_id`)
    REFERENCES `mydb`.`PHYSICIAN` (`physician_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PHYSICIAN_has_DIAGNOSIS_DIAGNOSIS1`
    FOREIGN KEY (`DIAGNOSIS_diagnosis_id`)
    REFERENCES `mydb`.`DIAGNOSIS` (`diagnosis_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_DIAGNOSIS_RECORD_PATIENT1`
    FOREIGN KEY (`PATIENT_patient_id`)
    REFERENCES `mydb`.`PATIENT` (`patient_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
