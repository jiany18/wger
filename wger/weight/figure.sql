DROP DATABASE IF EXISTS figure_tracker;

CREATE DATABASE IF NOT EXISTS figure_tracker;

USE figure_tracker;

DROP TABLE IF EXISTS figures;

CREATE TABLE IF NOT EXISTS figures (
	track_d			DATE,
    weight			DOUBLE,
    fat				DOUBLE,
    bmi				DOUBLE,
    bust			INT,
    waist			INT,
    upper_arms		INT,
    forearms		INT,
    hips			INT,
    thigh			INT,
    calves			INT,
    PRIMARY KEY(track_d)
) Engine = innodb;

-- add entry
-- add measurement
-- add view (lastly entered)

DROP PROCEDURE IF EXISTS add_entry;

DELIMITER //

CREATE PROCEDURE add_entry(IN track_d1 DATE, IN weight1 DOUBLE, IN fat1 DOUBLE,
IN bmi1 DOUBLE,IN bust1 INT,IN waist1 INT,IN upper_arms1 INT,IN forearms1 INT,
IN hips1 INT, IN thigh1 INT, IN calves1 INT)
BEGIN
	DECLARE sql_error INT DEFAULT FALSE;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
    IF track_d1 IS NULL THEN
		SET track_d1 = NOW();
	END IF;
    
	INSERT INTO figures(track_d, weight, fat, bmi,bust,waist,upper_arms, forearms,hips,thigh,calves)
    VALUES(track_d1, weight1, fat1, bmi1,bust1,waist1,upper_arms1, forearms1,hips1,thigh1,calves1);

    
	IF sql_error = FALSE THEN
		COMMIT;
        SELECT "Successfully added";
    ELSE
		ROLLBACK;
		SELECT "Entry was unsuccessful.";
	END IF;
END //

DELIMITER ;

DROP TABLE IF EXISTS new_figure;

CREATE TABLE IF NOT EXISTS new_figure (
	udate			DATE,
    weight			DOUBLE,
    fat				DOUBLE,
    bmi				DOUBLE,
    bust			INT,
    waist			INT,
    upper_arms		INT,
    forearms		INT,
    hips			INT,
    thigh			INT,
    calves			INT,
    PRIMARY KEY(udate)
) Engine = innodb;

DROP VIEW IF EXISTS latest;
CREATE VIEW latest AS
SELECT weight,fat, bmi, bust, waist, upper_arms, forearms, hips, thigh, calves
FROM new_figure
ORDER BY udate DESC
LIMIT 1;

DROP TRIGGER IF EXISTS update_new_figure;

DELIMITER //

CREATE TRIGGER update_new_figure
AFTER INSERT
ON figures
FOR EACH ROW
BEGIN
	DECLARE diff INT DEFAULT FALSE;
    DECLARE COUNT INT;
    DECLARE date2 DATE;
    DECLARE weight2 DOUBLE;
    DECLARE fat2 DOUBLE;
    DECLARE bmi2 DOUBLE;
    DECLARE bust2 INT;
    DECLARE waist2 INT;
    DECLARE ua2 INT;
    DECLARE fa2 INT;
    DECLARE hips2 INT;
    DECLARE thigh2 INT;
    DECLARE calves2 INT;
    
	SET COUNT = (SELECT COUNT(*) FROM new_figure);
    SELECT udate, weight, fat, bmi, bust,waist, upper_arms, forearms, hips, thigh,calves
		FROM new_figure
		ORDER BY udate DESC
		LIMIT 1
		INTO date2, weight2, fat2, bmi2, bust2,waist2, ua2,fa2, hips2, thigh2,calves2;
    
	IF COUNT = 0 THEN
		INSERT INTO new_figure(udate, weight, fat, bmi,bust,waist,upper_arms,forearms,hips,thigh,calves)
        VALUES(new.track_d, NEW.weight, NEW.fat, NEW.bmi, NEW.bust, NEW. waist, NEW.upper_arms,NEW.forearms,NEW.hips,NEW.thigh,NEW.calves);
	ELSE
		IF NEW.weight IS NOT NULL THEN
			SET diff = TRUE;
			SET weight2 = NEW.weight;
		END IF;

		IF NEW.fat IS NOT NULL THEN
			SET diff = TRUE;
			SET fat2 = NEW.fat;
		END IF;

		IF NEW.bmi IS NOT NULL THEN
			SET diff = TRUE;
			SET bmi2 = NEW.bmi;
		END IF;
        
        IF NEW.bust IS NOT NULL THEN
			SET diff =TRUE;
            SET bust2 = NEW.bust;
		END IF;
        
        IF NEW.waist IS NOT NULL THEN
			SET diff =TRUE;
            SET waist2 = NEW.waist;
		END IF;
        
        IF NEW.upper_arms IS NOT NULL THEN
			SET diff =TRUE;
            SET ua2 = NEW.upper_arms;
		END IF;
        
        IF NEW.forearms IS NOT NULL THEN
			SET diff =TRUE;
            SET fa2 = NEW.forearms;
		END IF;
        
        IF NEW.hips IS NOT NULL THEN
			SET diff =TRUE;
            SET hips2 = NEW.hips;
		END IF;
        
        IF NEW.thigh IS NOT NULL THEN
			SET diff =TRUE;
            SET thigh2 = NEW.thigh;
		END IF;
        
        IF NEW.calves IS NOT NULL THEN
			SET diff =TRUE;
            SET calves2 = NEW.calves;
		END IF;
        
	
		IF diff = TRUE THEN
			INSERT INTO new_figure(udate, weight, fat, bmi,bust,waist,upper_arms,forearms,hips,thigh,calves)
			VALUES(NEW.track_d, weight2, fat2, bmi2,bust2,waist2,ua2,fa2,hips2,thigh2,calves2);
		END IF;
	END IF;

END //

DELIMITER ;


-- -- Testing
-- CALL add_entry("2022-04-22", 75.4, 27.9, 24.9, 96, 69, 34, 25, 104,63,40);
-- CALL add_entry(NULL, 74, 27.2, 24.4, 96, 67, null,null,108,null,null);
-- CALL add_entry("2022-06-01", 70, null,null,null,66, 31, 23, null, 62,38);


-- select*
-- from figures;

-- select*
-- from new_figure;

-- select*
-- from latest;
