(test-group "the-price-is-right"
	(test-equal #f (the-price-is-right 100 '()) )
   	(test-equal #f (the-price-is-right 100 '(200 300 150)) )
      	(test-equal 150 (the-price-is-right 195 '(200 300 150)) )
   	(test-equal 200 (the-price-is-right 295 '(200 300 150)) )
   	(test-equal 300 (the-price-is-right 500 '(200 300 150)) )
   	(test-equal 400 (the-price-is-right 500 '(250 200 350 600 300 400 150 550)) )
     	(test-equal 5 (the-price-is-right 10 '(2 200 3 5 20 400 150 550)) )
   	(test-equal 1001 (the-price-is-right 10000 '(990 991 992 993 994 995 996 997 1001)) )
) 



	
