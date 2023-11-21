Rails.configuration.stripe = { 
  :publishable_key => 'pk_test_51O1rNUHNFIrss4LMGbtQoG6GyKUWWLCdSqgz3EhbvHaIKAzVdNVBdRQVlu2PBxaZuCuIBmjuIzpjcVRuEeBZH2YA00fK5qf4cO',
  :secret_key => 'sk_test_51O1rNUHNFIrss4LMZAyQH3Sm6XBNsk9BoCiA56Kg5QyIBkBUwl1GDzys39Sjw03GqgJbEFJ1SDxx5ovdKH7PHqH800ZMa1DaHX'
} 
Stripe.api_key = Rails.configuration.stripe[:secret_key]