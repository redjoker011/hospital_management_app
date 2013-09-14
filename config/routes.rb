HospitalApp::Application.routes.draw do

  scope "(:locale)", locale: /en/ do

    resources :users do
      member do
        get :change_password
        put :update_password
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

    match '/reports', :to => "reports#reports"

    match '/my_reports', :to => "reports#my_reports"

    match '/fetchReports', :to => "reports#fetch_reports"

    match '/fetch_my_reports', :to => "reports#fetch_my_reports"

    match '/fetchReportsPdf', :to => "reports#fetch_reports_download"

    match '/login', :to => 'sessions#login'

    match '/sign_out', :to => 'sessions#destroy'

    match '/searchPatients', :to => 'patients#searchPatients'

    match '/search', :to => 'patients#search'

    match '/downloadPdf', :to => 'patients#downloadPdf'
  end
end
