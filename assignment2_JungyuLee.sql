-- Q1
DECLARE 
  lv_total_spending NUMBER;
  lv_product_id bb_product.idproduct%TYPE;
  lv_item_price bb_product.price%TYPE;
  lv_quantity NUMBER := 0; -- used to count
BEGIN 
  -- test 1: a total spending amount of $100 & product ID 4
  lv_total_spending := 100;
  lv_product_id := 4;
  
  SELECT price
    INTO lv_item_price
    FROM bb_product
    WHERE idproduct = lv_product_id;

  WHILE lv_total_spending >= lv_item_price LOOP
    lv_total_spending := lv_total_spending - lv_item_price;
    lv_quantity := lv_quantity + 1;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('With $' || (lv_total_spending + lv_quantity * lv_item_price) || 
    ', you can purchase ' || lv_quantity || ' items of product ID ' || lv_product_id);
    
  lv_quantity := 0; -- reset the count
  
  -- test 2: (my choice) a total spending amount of $200 & product ID 2
  lv_total_spending := 200;
  lv_product_id := 2;
  
  SELECT price
    INTO lv_item_price
    FROM bb_product
    WHERE idproduct = lv_product_id;

  WHILE lv_total_spending >= lv_item_price LOOP
    lv_total_spending := lv_total_spending - lv_item_price;
    lv_quantity := lv_quantity + 1;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('With $' || (lv_total_spending + lv_quantity * lv_item_price) || 
    ', you can purchase ' || lv_quantity || ' items of product ID ' || lv_product_id);
END;

-- Q2
DECLARE
  TYPE basket_id_array IS TABLE OF bb_basket.idbasket%TYPE;
  lv_basket_ids basket_id_array := basket_id_array(5, 12);
  lv_quantity bb_basket.quantity%TYPE;
  lv_shipping_rate NUMBER;
BEGIN
  FOR i IN 1..lv_basket_ids.COUNT LOOP
    SELECT quantity
      INTO lv_quantity
      FROM bb_basket
      WHERE idbasket = lv_basket_ids(i);

    IF lv_quantity <= 3 THEN
      lv_shipping_rate := 5.00;
    ELSIF lv_quantity >= 4 AND lv_quantity <= 6 THEN
      lv_shipping_rate := 7.50;
    ELSIF lv_quantity >= 7 AND lv_quantity <= 10 THEN
      lv_shipping_rate := 10.00;
    ELSE
      lv_shipping_rate := 12.00;
    END IF;

    DBMS_OUTPUT.PUT_LINE('The shipping cost for basket ID ' || lv_basket_ids(i) || ' is $' || lv_shipping_rate);
  END LOOP;
END;

-- Q3
DECLARE
  lv_basket_id bb_basket.idbasket%TYPE := 12;
  lv_subtotal bb_basket.subtotal%TYPE;
  lv_shipping bb_basket.shipping%TYPE;
  lv_tax bb_basket.tax%TYPE;
  lv_total bb_basket.total%TYPE;
BEGIN
  SELECT subtotal, shipping, tax, total
    INTO lv_subtotal, lv_shipping, lv_tax, lv_total
    FROM bb_basket
    WHERE idbasket = lv_basket_id;
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Order Summary for basket ID ' || lv_basket_id);
  DBMS_OUTPUT.PUT_LINE('Subtotal: $' || lv_subtotal);
  DBMS_OUTPUT.PUT_LINE('Shipping: $' || lv_shipping);
  DBMS_OUTPUT.PUT_LINE('Tax: $' || lv_tax);
  DBMS_OUTPUT.PUT_LINE('Total: $' || lv_total);
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
END;

-- Q4
DECLARE
  lv_basket_id bb_basket.idbasket%TYPE := 12;
  rec_order_summary bb_basket%ROWTYPE;
BEGIN 
  SELECT * 
    INTO rec_order_summary
    FROM bb_basket
    WHERE idbasket = lv_basket_id;
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Order Summary for basket ID ' || lv_basket_id);
  DBMS_OUTPUT.PUT_LINE('Subtotal: $' || rec_order_summary.subtotal);
  DBMS_OUTPUT.PUT_LINE('Shipping: $' || rec_order_summary.shipping);
  DBMS_OUTPUT.PUT_LINE('Tax: $' || rec_order_summary.tax);
  DBMS_OUTPUT.PUT_LINE('Total: $' || rec_order_summary.total);
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
END;

-- Q5.
DECLARE
  TYPE movie_id_array IS TABLE OF mm_movie.movie_id%TYPE;
  lv_movie_ids movie_id_array := movie_id_array('4', '25');
  lv_movie_title mm_movie.movie_title%TYPE;
  lv_rental_count NUMBER;
  lv_rental_rating VARCHAR2(10);
BEGIN
  FOR i IN 1..lv_movie_ids.COUNT LOOP
    BEGIN
      SELECT movie_title, COUNT(*)
      INTO lv_movie_title, lv_rental_count
      FROM mm_movie
      JOIN mm_rental ON mm_movie.movie_id = mm_rental.movie_id
      WHERE mm_movie.movie_id = lv_movie_ids(i)
      GROUP BY movie_title;

      IF lv_rental_count <= 5 THEN
        lv_rental_rating := 'Dump';
      ELSIF lv_rental_count <= 20 THEN
        lv_rental_rating := 'Low';
      ELSIF lv_rental_count <= 35 THEN
        lv_rental_rating := 'Mid';
      ELSE
        lv_rental_rating := 'High';
      END IF;
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
      DBMS_OUTPUT.PUT_LINE('Movie ID: ' || lv_movie_ids(i));
      DBMS_OUTPUT.PUT_LINE('Movie Title: ' || lv_movie_title);
      DBMS_OUTPUT.PUT_LINE('Rental Count: ' || lv_rental_count);
      DBMS_OUTPUT.PUT_LINE('Rental Rating: ' || lv_rental_rating);
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('No movie found with the specified ID: ' || lv_movie_ids(i));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred for movie ID: ' || lv_movie_ids(i));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    END;
  END LOOP;
END;



