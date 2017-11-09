HospitalApp::Application.routes.draw do

  scope "(:locale)", locale: /en/ do

    resources :users do
      member do
        get :change_password
        patch :update_password
      end
    end

    resources :sessions
    resources :patients do
      member do
        get :generate_invoice
        resources :user_patients do
          member do
            get :fetch
          end
        end
      end
    end

    root :to => "sessions#login"

    get '/reports', :to => "reports#reports"

    get '/my_reports', :to => "reports#my_reports"

    get '/fetchReports', :to => "reports#fetch_reports"

    get '/fetch_my_reports', :to => "reports#fetch_my_reports"

    get '/fetchReportsPdf', :to => "reports#fetch_reports_download"

    get '/login', :to => 'sessions#login'

    get '/sign_out', :to => 'sessions#destroy'

    get '/searchPatients', :to => 'patients#searchPatients'

    get '/search', :to => 'patients#search'

    post '/downloadPdf', :to => 'patients#downloadPdf'
  end
end
