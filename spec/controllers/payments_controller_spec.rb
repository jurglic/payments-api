require 'rails_helper'

RSpec.describe PaymentsController, type: :request do
  describe 'GET /payments' do
    let!(:payment_1) { create(:payment, amount: '100.12') }
    let!(:payment_2) { create(:payment, amount: '9.99') }

    context 'when successful' do
      before do
        get '/payments', headers: { 'HTTP_ACCEPT': 'application/vnd.api+json' }
      end

      it 'responds with status ok' do
        expect(response.status).to eq(200)
      end

      it 'responds with api+json content type' do
        expect(response.headers['Content-Type']).to start_with('application/vnd.api+json')
      end

      it 'returns all payment resources in jsonapi format' do
        expect(json_response.data.length).to eq(2)
        expect_to_be_jsonapi_payment_resource(json_response.data.first)
        expect_to_be_jsonapi_payment_resource(json_response.data.second)
      end
    end

    context 'when unsuccessful' do
      context 'when accept header not set to jsonapi type' do
        it 'fails with status unsupported media' do
          get '/payments', headers: { 'HTTP_ACCEPT': 'application/json' }

          expect(response.status).to eq(415)
        end
      end
    end
  end

  describe 'GET /payments/:id' do
    let!(:payment) { create(:payment) }
    let!(:other_payment) { create(:payment) }

    before do
      get "/payments/#{payment.id}", headers: { 'HTTP_ACCEPT': 'application/vnd.api+json' }
    end

    context 'when successful' do
      it 'responds with status ok' do
        expect(response.status).to eq(200)
      end

      it 'responds with api+json content type' do
        expect(response.headers['Content-Type']).to start_with('application/vnd.api+json')
      end

      it 'returns payment resource in jsonapi format' do
        expect(json_response.data.id).to eq(payment.id)
        expect_to_be_jsonapi_payment_resource(json_response.data)
      end
    end

    context 'when unsuccessful' do
      context 'when accept header not set to jsonapi type' do
        it 'fails with status unsupported media' do
          get "/payments/#{payment.id}", headers: { 'HTTP_ACCEPT': 'application/json' }

          expect(response.status).to eq(415)
        end
      end

      context 'when payment resource not found' do
        before do
          get '/payments/XYZ', headers: { 'HTTP_ACCEPT': 'application/vnd.api+json' }
        end

        it 'fails with status not found' do
          expect(response.status).to eq(404)
        end

        it 'returns not found error message' do
          expect(json_response.errors.first.type).to eq('Resource Not Found')
        end
      end
    end
  end

  describe 'POST /payments' do
    let(:payment_attributes) { attributes_for(:payment).merge(amount: '123.45', currency: 'EUR') }
    let(:payload) {
      {
        data: {
          type: 'Payment',
          attributes: payment_attributes
        }
      }
    }

    before do
      post '/payments', params: payload, as: :json, headers: { 'HTTP_ACCEPT': 'application/vnd.api+json' }
    end

    context 'when successful' do
      it 'responds with status ok' do
        expect(response.status).to eq(201)
      end

      it 'responds with api+json content type' do
        expect(response.headers['Content-Type']).to start_with('application/vnd.api+json')
      end

      it 'creates and persists new payment resource' do
        expect(Payment.exists?(json_response.data.id)).to eq(true)
      end

      it 'returns newly created payment resources in jsonapi format' do
        expect(json_response.data.id).to be_present
        expect_to_be_jsonapi_payment_resource(json_response.data)
      end
    end

    context 'when unsuccessful' do
      context 'when accept header not set to jsonapi type' do
        it 'fails with status unsupported media' do
          post '/payments', params: payload, as: :json, headers: { 'HTTP_ACCEPT': 'application/json' }

          expect(response.status).to eq(415)
        end
      end

      context 'when payload is missing required attributes' do
        let(:payment_attributes) { attributes_for(:payment).except(:amount) }

        before do
          post '/payments', params: payload, as: :json, headers: { 'HTTP_ACCEPT': 'application/vnd.api+json' }
        end

        it 'fails with status unprocessable entity' do
          expect(response.status).to eq(422)
        end

        it 'returns invalid resource error message' do
          expect(json_response.errors.first.type).to eq('Resource Invalid')
          expect(json_response.errors.first.detail).to match("Amount can't be blank")
        end
      end
    end
  end
end