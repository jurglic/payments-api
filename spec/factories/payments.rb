FactoryBot.define do
  factory :payment do
    amount { '99.99' }
    currency { 'GBP' }
    end_to_end_reference { 'Wil piano Jan' }
    numeric_reference { '1002001' }
    payment_id { '123456789012345678' }
    payment_purpose { 'Paying for goods/services' }
    payment_scheme { 'FDS' }
    payment_type { 'Credit' }
    processing_date { '2017-01-18' }
    reference { "Payment for Em's piano lessons" }
    scheme_payment_sub_type { 'InternetBanking' }
    scheme_payment_type { 'ImmediatePayment' }
    version { 0 }
    organisation_id { '743d5b63-8e6f-432e-a8fa-c5d8d2ee5fcb' }

    beneficiary_party { {
      account_name: 'W Owens',
      account_number: '31926819',
      account_number_code: 'BBAN',
      account_type: 0,
      address: '1 The Beneficiary Localtown SE2',
      bank_id: '403000',
      bank_id_code: 'GBDSC',
      name: 'Wilfred Jeremiah Owens',
    } }

    debtor_party { {
      account_name: 'EJ Brown Black',
      account_number: 'GB29XABC10161234567801',
      account_number_code: 'IBAN',
      address: '10 Debtor Crescent Sourcetown NE1',
      bank_id: '203301',
      bank_id_code: 'GBDSC',
      name: 'Emelia Jane Brown',
    } }

    sponsor_party { {
      account_number: '56781234',
      bank_id: '123123',
      bank_id_code: 'GBDSC',
    } }

    charges_information { {
      bearer_code: 'SHAR',
      sender_charges: [
        { amount: '5.00', currency: 'GBP' },
        { amount: '10.00', currency: 'USD' },
      ],
      receiver_charges_amount: '1.00',
      receiver_charges_currency: 'USD',
    } }

    fx { {
      contract_reference: 'FX123',
      exchange_rate: '2.00000',
      original_amount: '200.42',
      original_currency: 'USD',
    } }
  end
end
