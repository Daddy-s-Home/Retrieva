-- Replace the broad item categories with the specific client list.
-- Old values are remapped before the enum is narrowed.

ALTER TABLE lost_items
  MODIFY category ENUM(
    'Electronics','Clothing','IDs & Cards','Accessories','Books & Papers','Others',
    'Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other'
  ) NOT NULL;

ALTER TABLE found_items
  MODIFY category ENUM(
    'Electronics','Clothing','IDs & Cards','Accessories','Books & Papers','Others',
    'Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other'
  ) NOT NULL;

UPDATE lost_items SET category = 'ID' WHERE category = 'IDs & Cards';
UPDATE found_items SET category = 'ID' WHERE category = 'IDs & Cards';
UPDATE lost_items SET category = 'Book' WHERE category = 'Books & Papers';
UPDATE found_items SET category = 'Book' WHERE category = 'Books & Papers';
UPDATE lost_items SET category = 'Other' WHERE category IN ('Electronics','Clothing','Accessories','Others');
UPDATE found_items SET category = 'Other' WHERE category IN ('Electronics','Clothing','Accessories','Others');

ALTER TABLE lost_items
  MODIFY category ENUM(
    'Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other'
  ) NOT NULL;

ALTER TABLE found_items
  MODIFY category ENUM(
    'Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other'
  ) NOT NULL;
