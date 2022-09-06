(deffunction cls ()
	(for (bind ?i 0) (< ?i 32) (++ ?i)
        (printout t crlf)
    )
)

(deffunction menu ()
    (printout t "=================================" crlf)
    (printout t "|         MALONE DELIGHTS       |" crlf)
    (printout t "=================================" crlf)
	(printout t "| 1. View Foods                 |" crlf)
    (printout t "| 2. Add Food                   |" crlf)
    (printout t "| 3. Update Food                |" crlf)
    (printout t "| 4. Delete Food                |" crlf)
    (printout t "| 5. Food Planning Consultation |" crlf)
    (printout t "| 6. Exit                       |" crlf)
    (printout t "=================================" crlf)
    
)

(deffunction subMenu ()
    (bind ?choice2 -1)
    (cls)
    (printout t "Categories to Choose" crlf)
    (printout t "--------------------" crlf)
    (printout t "1. Food" crlf)
    (printout t "2. Food Plans" crlf)
    (while (or(< ?choice2 0) (> ?choice2 2))
    	(printout t "Choose [1..2 |0 to go back to main menu]: ")
        (try 
        	(bind ?choice2 (integer(read)))
        catch (bind ?choice2 -1)
    	)   
    )
    (return ?choice2)
)

(deftemplate food
    (slot nameF)
    (slot rating)    
    (slot typeF)
    (slot priceF)
)

(deftemplate foodPlan
    (slot nameFP)
    (slot duration)    
    (slot priceFP)
    (slot foodName)
    (slot quantity)
)

(deffacts insert-food
    (food (nameF "Tomato Salsa") (rating 5.0) (typeF "Mexican") (priceF 5.00))
    (food (nameF "Margherita Pizza") (rating 4.7) (typeF "Italian") (priceF 20.00))
    (food (nameF "Szechwan Chili Chicken") (rating 4.0) (typeF "Chinese") (priceF 2.00))
    (food (nameF "Stir Fried Tofu With Rice") (rating 4.9) (typeF "Chinese") (priceF 4.00))
    (food (nameF "Pork Fried Rice") (rating 4.2) (typeF "Chinese") (priceF 7.50))
	(food (nameF "Pasta Carbonara") (rating 5.0) (typeF "Italian") (priceF 15.00))
    (food (nameF "Chicken Quesadillas") (rating 4.5) (typeF "Mexican") (priceF 8.00))      
)

(deffacts insert-foodPlan
    (foodPlan (nameFP "Rice Tofu Package") (duration 365) (priceFP 16685.71) (foodName "Stir Fried Tofu with Rice") (quantity 100))
	(foodPlan (nameFP "Salsa Package") (duration 120) (priceFP 34285.71) (foodName "Tomato Salsa") (quantity 500))
    (foodPlan (nameFP "Pizza Package") (duration 300) (priceFP 137142.85) (foodName "Margherita Pizza") (quantity 200))
)

(reset)

(defglobal 
    ?*current_totalFood* = 7
    ?*current_totalFoodPlan* = 3
    ?*cekfood* = ""
    ?*cekprice* = -1.0
)

(defrule do-print-food
    (print-food)
    (food (nameF ?name) (rating ?rating) (typeF ?type) (priceF ?price))
    =>
    (printout t "ini food" ?name crlf)  
)

(defrule done-print-food
    ?id <- (done-foodprint)
	?factId <- (print-food)
    =>
    (retract ?factId)    
    (retract ?id)
)

(defrule do-print-foodPlan
    (print-foodPlan)
    (foodPlan (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP) (foodName ?foodName) (quantity ?quantity))
    =>
    (printout t "ini food" ?nameFP crlf)  
)

(defrule done-print-foodPlan
    ?id <- (done-foodPlanprint)
	?factId <- (print-foodPlan)
    =>
    (retract ?factId)    
    (retract ?id)
)

(deffunction viewFood ()
    (assert (print-food))
    (run)
    (assert (done-foodprint))
    (run)
)

(deffunction viewFoodPlan ()
	(assert (print-foodPlan))
    (run)
    (assert (done-foodPlanprint))
    (run)
)

(deffunction addFood ()
	(bind ?nameF "")
    (bind ?rating -1)
    (bind ?typeF "")
    (bind ?priceF 0.0)
  
    ;name food
	(while(or (<(str-length ?nameF) 5) (>(str-length ?nameF) 28))
        (printout t "Input new Foods name [5 - 28 Characters]: ")
        (bind ?nameF (readline))
        (if (eq(regexp "[a-zA-Z ]+" ?nameF) FALSE) then
           	(bind ?nameF "")
        )
	)	
    
 	;rating food
	(while (or(< ?rating 0.0) (> ?rating 5.0))
        (printout t "Input new Foods rating [0.0 - 5.0 stars]: ")
        (bind ?rating (read))
        
        (if (eq(floatp ?rating) FALSE) then
            (bind ?rating -1)
            (printout t "Input must be a float" crlf)
        )
	)
    
    ;type food
    (while (and (and (neq ?typeF "Italian") 
                (neq ?typeF "Chinese"))
            	(neq ?typeF "Mexican"))
        
        (printout t "Input new Foods type [Italian | Chinese | Mexican] : ")
        (bind ?typeF (readline))
    ) 
    
    ;price food
    ;italian
    (if (eq ?typeF "Italian")
        then
    	(while (or (< ?priceF 15.0) (> ?priceF 80.0))
        	(printout t "Food Price [15.0 - 80.0]: $")
        	(bind ?priceF (read))
        
        	(if (eq(floatp ?priceF)FALSE) then
            	(bind ?priceF -1)
            	(printout t "Input must be a float" crlf)
            )
        )
     )    
    ;chinese
    (if (eq ?typeF "Chinese")
        then
    	(while (or (< ?priceF 1.50) (> ?priceF 20.0))
        	(printout t "Food Price [1.50 - 20.0]: $")
        	(bind ?priceF (read))
        
        	(if (eq(floatp ?priceF)FALSE) then
            	(bind ?priceF -1)
            	(printout t "Input must be a float" crlf)
            )
        )
     )
    
    ;Mexican
    (if (eq ?typeF "Mexican")
        then
    	(while (or (< ?priceF 5.0) (> ?priceF 25.0))
        	(printout t "Food Price [5.0 - 25.0]: $")
        	(bind ?priceF (read))
        
        	(if (eq(floatp ?priceF)FALSE) then
            	(bind ?priceF -1)
            	(printout t "Input must be a float" crlf)
            )
        )
    )
    
    (assert (food (nameF ?nameF) (rating ?rating) (typeF ?typeF) (priceF ?priceF)))
	(printout t ?nameF " Succesfully added!")
    (++ ?*current_totalFood*)

    (readline)
)

(defrule cek-food
    (cekFood ?cf)
    (not (food (nameF ?cf)))
    =>
    (bind ?*cekfood* "")
)

(defrule done-cek-food
    ?id <- (done-cekFood)
	?factId <- (cekFood ?*cekfood*)
    =>
    (retract ?factId)    
    (retract ?id)
)

(defrule cek-price
    (cekPrice ?cp)
    (food (nameF ?cp)(priceF ?p))
    =>
    (bind ?*cekprice* ?p)
)

(defrule done-cek-price
    ?id <- (done-cekPrice)
	?factId <- (cekPrice ?*cekprice*)
    =>
    (retract ?factId)    
    (retract ?id)
)

(deffunction addFoodPlan ()
    (bind ?nameFP "")
    (bind ?duration -1)    
    (bind ?priceFP -1.0)
    (bind ?foodName "")
    (bind ?quantity -1)
    
    
    ;name food plan
	(while(or (<(str-length ?nameFP) 1) (>(str-length ?nameFP) 20))
        (printout t "Input new plans name [Must end with 'Plan' | < 20 Characters]: ")
        (bind ?nameFP (readline))
        (if (eq(regexp "[a-zA-Z ]+Plan" ?nameFP) FALSE) then
           	(bind ?nameFP "")
        )
	)
    
    ;duration food plan
	(while (or(< ?duration 10) (> ?duration 3650))
        (printout t "Input new plans duration [10 days to 10 years | Insert in days]: ")
        (bind ?duration (read))
        
        (if (eq(integerp ?duration) FALSE) then
            (bind ?duration -1)
            (printout t "Input must be a integer" crlf)
        )
	)
    
    ;food name
    (viewFood)
    (while (<(str-length ?foodName) 1)
        (bind ?*cekfood* "")
        (printout t "Input a Food for this plan: ")
        (bind ?*cekfood* (readline))
        (assert (cekFood ?*cekfood*))
    	(run)
    	(assert (done-cekFood))
    	(run)
        (if (>(str-length ?*cekfood*) 1) then
            (bind ?foodName ?*cekfood*)
        )
	)
    
    ;food quantity
	(while (< ?quantity 10)
        (printout t "Input Food quantity distributed per week [> 10 portion]: ")
        (bind ?quantity (read))
        
        (if (eq(integerp ?quantity) FALSE) then
            (bind ?quantity -1)
            (printout t "Input must be a integer" crlf)
        )
	)
    
    (assert (cekPrice ?foodName))
    (run)
    (assert (done-cekPrice))
    (run)
    (bind ?priceFP (* (* (* ?*cekprice* 0.8) (/ ?duration 7)) ?quantity))
	(printout t "This plans total price is $"?priceFP crlf)
    
    (assert (foodPlan (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP) (foodName ?foodName) (quantity ?quantity)))
    (printout t ?nameFP " Succesfully added!" crlf)
    (++ ?*current_totalFoodPlan*)
    (readline)
)

(deffunction updateFood ()
    (viewFood)
    (bind ?fact_id -1)
    (while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFood*))
    	(printout t "Input number to be updated : " crlf) 
    	(bind ?fact_id(read))
    )
    
    (try
	    (bind ?nameF "")
    	(bind ?rating -1)
   		(bind ?typeF "")
    	(bind ?priceF 0.0)
  
    	;name food
		(while(or (<(str-length ?nameF) 5) (>(str-length ?nameF) 28))
        	(printout t "Input new Foods name [5 - 28 Characters]: ")
        	(bind ?nameF (readline))
        	(if (eq(regexp "[a-zA-Z]+" ?nameF) FALSE) then
           		(bind ?nameF "")
        	)
		)	
    
 		;rating food
		(while (or(< ?rating 0.0) (> ?rating 5.0))
        	(printout t "Input new Foods rating [0.0 - 5.0 stars]: ")
        	(bind ?rating (read))
        
        	(if (eq(floatp ?rating) FALSE) then
            	(bind ?rating -1)
            	(printout t "Input must be a float" crlf)
        	)
		)
    
    	;type food
    	(while (and (and (neq ?typeF "Italian") 
                (neq ?typeF "Chinese"))
            	(neq ?typeF "Mexican"))
        
        	(printout t "Input new Foods type [Italian | Chinese | Mexican] : ")
        	(bind ?typeF (readline))
    	) 
    
    	;price food
    	;italian
    	(if (eq ?typeF "Italian")
        	then
    		(while (or (< ?priceF 15.0) (> ?priceF 80.0))
        		(printout t "Food Price [15.0 - 80.0]: $")
        		(bind ?priceF (read))
        
        		(if (eq(floatp ?priceF)FALSE) then
            		(bind ?priceF -1)
            		(printout t "Input must be a float" crlf)
            	)
        	)
     	)    
    	;chinese
    	(if (eq ?typeF "Chinese")
        	then
    		(while (or (< ?priceF 1.50) (> ?priceF 20.0))
        		(printout t "Food Price [1.50 - 20.0]: $")
        		(bind ?priceF (read))
        
        		(if (eq(floatp ?priceF)FALSE) then
            		(bind ?priceF -1)
            		(printout t "Input must be a float" crlf)
            	)
        	)
     	)
    
    	;Mexican
    	(if (eq ?typeF "Mexican")
        	then
    		(while (or (< ?priceF 5.0) (> ?priceF 25.0))
        		(printout t "Food Price [5.0 - 25.0]: $")
        		(bind ?priceF (read))
        
        		(if (eq(floatp ?priceF)FALSE) then
            		(bind ?priceF -1)
            		(printout t "Input must be a float" crlf)
            	)
        	)
    	)
           
        (modify ?fact_id (nameF ?nameF) (rating ?rating) (typeF ?typeF) (priceF ?priceF))
        (printout t "Update Succesful!")
        (viewFood)
        
     catch
        (printout t "Item not found ...")
    )
    
    (readline)
)

(deffunction updateFoodPlan ()
    (viewFoodPlan)
    (bind ?fact_id -1)
    (while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFoodPlan*))
    	(printout t "Input number to be updated : " crlf) 
    	(bind ?fact_id(read))
    )
	(try
		(bind ?nameFP "")
    	(bind ?duration -1)    
    	(bind ?priceFP -1.0)
    	(bind ?foodName "")
    	(bind ?quantity -1)
        
    	;name food plan
		(while(or (<(str-length ?nameFP) 1) (>(str-length ?nameFP) 20))
        	(printout t "Input new plans name [Must end with 'Plan' | < 20 Characters]: ")
        	(bind ?nameFP (readline))
        	(if (eq(regexp "[a-zA-Z ]+Plan" ?nameFP) FALSE) then
           		(bind ?nameFP "")
        	)
		)
    
    	;duration food plan
		(while (or(< ?duration 10) (> ?duration 3650))
        	(printout t "Input new plans duration [10 days to 10 years | Insert in days]: ")
        	(bind ?duration (read))
        
        	(if (eq(integerp ?duration) FALSE) then
            	(bind ?duration -1)
            	(printout t "Input must be a integer" crlf)
        	)
		)
    
    	;food name
    	(viewFood)
    	(while (<(str-length ?foodName) 1)
        	(bind ?*cekfood* "")
        	(printout t "Input a Food for this plan: ")
        	(bind ?*cekfood* (readline))
        	(assert (cekFood ?*cekfood*))
    		(run)
    		(assert (done-cekFood))
    		(run)
        	(if (>(str-length ?*cekfood*) 1) then
            	(bind ?foodName ?*cekfood*)
        	)
		)
    
    	;food quantity
		(while (< ?quantity 10)
        	(printout t "Input Food quantity distributed per week [> 10 portion]: ")
        	(bind ?quantity (read))
        
        	(if (eq(integerp ?quantity) FALSE) then
            	(bind ?quantity -1)
            	(printout t "Input must be a integer" crlf)
        	)
		)
    
    	(assert (cekPrice ?foodName))
    	(run)
    	(assert (done-cekPrice))
    	(run)
    	(bind ?priceFP (* (* (* ?*cekprice* 0.8) (/ ?duration 7)) ?quantity))
		(printout t "This plans total price is $"?priceFP crlf)
    
    	(modify ?fact_id (nameFP ?nameFP) (duration ?duration) (priceFP ?priceFP) (foodName ?foodName) (quantity ?quantity))
    
        (viewFoodPlan)
        
     catch
        (printout t "Item not found ...")
    )
    
    (readline)
)

(deffunction deleteFood ()
	(viewFood)
    (bind ?fact_id -1)
    (while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFood*))
    	(printout t "Item number to be deleted : ") 
    	(bind ?fact_id(read))
    )
    
    (try
        (fact-id ?fact_id)
        (retract ?fact_id )   
        (printout t "Delete Succesful!")
    catch
        (printout t "Food not found" crlf)
    )
    
    (readline)
)

(deffunction deleteFoodPlan ()
	(viewFoodPlan)
    (bind ?fact_id -1)
    (while (or(< ?fact_id 0 ) (> ?fact_id ?*current_totalFoodPlan*))
    	(printout t "Item number to be deleted : ") 
    	(bind ?fact_id(read))
    )
    
    (try
        (fact-id ?fact_id)
        (retract ?fact_id )   
        (printout t "Delete Succesful!")
    catch
        (printout t "Food not found" crlf)
    )
    (readline)
)

(bind ?choice 0)
(bind ?choice2 -1)
(while (neq ?choice 6)
    (bind ?choice 0)
    (cls)
    (menu)
    (while (or(< ?choice 1) (> ?choice 6))
        (printout t "Choose [1..6]: ")
    	(try 
        	(bind ?choice (integer(read)))
        catch (bind ?choice -1)
    	)
    )
    
    (if (eq ?choice 1)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(viewFood)
            
         elif(eq ?choice2 2)
            then
            (viewFoodPlan)
        )
        (if (neq ?choice2 0)
            then
        	(printout t "Press ENTER to back to main menu...")
        	(readline)
        )
        
     elif (eq ?choice 2)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(addFood)
            
         elif(eq ?choice2 2)
            then
            (addFoodPlan)
        )        
        
     elif (eq ?choice 3)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(updateFood)
            
         elif(eq ?choice2 2)
            then
            (updateFoodPlan)
        )
        
     elif (eq ?choice 4)
        then
        (cls)
        (bind ?choice2 (subMenu))
        
        (if(eq ?choice2 1)
            then
        	(deleteFood)
            
         elif(eq ?choice2 2)
            then
            (deleteFoodPlan)
        )

     elif (eq ?choice 5)
        then
        (cls)
        (printout t "5 Press enter to continue...")
        (readline)
    )  
)

