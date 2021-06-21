FactoryBot.define do
  factory :page do
    factory :root_page, class: Page do
      name    { 'root' }
      title   { 'root title' }
      text    { 'root text' }
      # page_id nil
    end

    factory :another_root_page, class: Page do
      name { 'root_page1' }
      title { 'root name 1' }
      text { 'root page 1' }
      # page_id nil
    end

    factory :sub1_page, class: Page do
      name { 'sub1_page_name' }
      title { 'sub1 page title' }
      text { 'sub1 page text' }
      association :parent, factory: :root_page
    end

    factory :sub2_page, class: Page do
      name { 'sub2_page_name' }
      title { 'sub2 page title' }
      text { 'sub2 page text' }
      association :parent, factory: :root_page
    end

    factory :sub1sub1_page, class: Page do
      name { 'sub1sub1_page_name' }
      title { 'sub1sub1 page title' }
      text { 'sub1sub1 page text' }
      association :parent, factory: :sub1_page
    end
  end
end
