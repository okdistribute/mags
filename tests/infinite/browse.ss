(test-group "browse"
	(test-equal "indiana.edu" (browse "indiana.edu" '()) )
   	(test-equal "google.com" (browse"indiana.edu" '("mapquest.com" "theonion.com" "npr.org" "nytimes.com" "google.com" "whitehouse.gov" back back back forward forward)) )
        (test-equal "apple.com/itunes" (browse "indiana.edu" '("google.com" back "ebay.com" back "apple.com/itunes" back forward "sourceforge.net" back back forward)) )
        (test-equal "moveon.org" (browse "slashdot.org" '(forward back back "moveon.org" back back forward "weather.com" back)) )
	(test-equal "reddit.com" (browse "google.com" '(back back back forward back forward "reddit.com" "funny.com" back "test.com" "pop.cap" back back back back forward)) ) 
   	(test-equal "bob.uk" (browse "weather.com" '("bob.uk" back forward back forward back forward back forward forward forward back forward)) )
) 


	
