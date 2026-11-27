-- Add the requested category options without removing legacy enum values or rewriting rows.
ALTER TABLE `lost_items`
  MODIFY `category` ENUM(
    'Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other',
    'Phones (Android)','Phones (Iphone)','ID lace','Food containers and utensils','Others'
  ) NOT NULL;

ALTER TABLE `found_items`
  MODIFY `category` ENUM(
    'Phone (Android)','Phone (Iphone)','Tablet','ID','Lace','Tumbler/Flask/Bottled Water','Bag','Shoes','Notebook','Book','Other',
    'Phones (Android)','Phones (Iphone)','ID lace','Food containers and utensils','Others'
  ) NOT NULL;
