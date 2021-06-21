require 'spec_helper'

describe 'routes for Pages' do
  it { expect(get('/')).to route_to('pages#show') }
  it { expect(get('/add')).to route_to('pages#add_root') }
  it { expect(post('/')).to route_to('pages#create_root') }
  it { expect(get('/name1/name2/name3')).to route_to('pages#show', path: 'name1/name2/name3') }
  it { expect(get('/name1/name2/name3/edit')).to route_to('pages#edit', path: 'name1/name2/name3') }
  it { expect(get('/name1/name2/name3/add')).to route_to('pages#add', path: 'name1/name2/name3') }
  it { expect(post('/name1/name2/name3')).to route_to('pages#create', path: 'name1/name2/name3') }
  it { expect(put('/name1/name2/name3')).to route_to('pages#update', path: 'name1/name2/name3') }
end
