-- Триггер для проверки уникальности номера комнаты
CREATE OR REPLACE FUNCTION check_room_number_unique()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM rooms WHERE number = NEW.number AND room_id != NEW.room_id) THEN
        RAISE SQLSTATE '42P08' USING MESSAGE = 'Комната с номером % уже существует', NEW.number;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER check_room_number_unique_trigger
BEFORE INSERT OR UPDATE ON rooms
FOR EACH ROW
EXECUTE PROCEDURE check_room_number_unique();

INSERT INTO rooms (number, floor_id, room_category_id, room_status_id) VALUES (104, 4, 2, 3); 


-- Триггер для проверки уникальности паспорта клиента
CREATE OR REPLACE FUNCTION check_client_passport_unique()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM clients
		 WHERE passport_series = NEW.passport_series
 		 AND passport_number = NEW.passport_number
 		 AND client_id != NEW.client_id) THEN
        RAISE SQLSTATE '42P08' USING MESSAGE = 'Клиент с паспортными данными % % уже существует', NEW.passport_series, NEW.passport_number;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER check_client_passport_unique_trigger
BEFORE INSERT OR UPDATE ON clients
FOR EACH ROW
EXECUTE PROCEDURE check_client_passport_unique();


-- Триггер для проверки уникальности паспорта клиента
CREATE OR REPLACE FUNCTION update_room_status_on_booking_delete()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE rooms SET room_status_id = 5 WHERE room_id = OLD.room_id;
    RETURN OLD;
END;
$$;

CREATE TRIGGER update_room_status_on_booking_delete_trigger
AFTER DELETE ON bookings
FOR EACH ROW
EXECUTE PROCEDURE update_room_status_on_booking_delete();
