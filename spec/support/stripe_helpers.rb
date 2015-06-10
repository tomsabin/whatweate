module StripeHelpers
  VALID_CARD = "4242424242424242"
  CARD_DECLINED = "4000000000000002"
  CARD_ERROR = "4000000000000341"

  VALID_CARD_TOKEN = "tok_16BmGWBb51nepfzbz2jrNiaX"
  CARD_ERROR_TOKEN = "tok_16BmHrBb51nepfzb6MnsBrlq"
  CARD_DECLINED_TOKEN = "tok_16BmIXBb51nepfzbkWvO7yhx"

  def self.generate_token(number: VALID_CARD, exp_month: rand(1..12), exp_year: 1.year.from_now.year, cvc: rand(100..999))
    Stripe::Token.create(card: {
      number:    number,
      exp_month: exp_month,
      exp_year:  exp_year,
      cvc:       cvc
    })
  end
end
