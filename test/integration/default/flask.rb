describe service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe service('flask-website') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe pip('virtualenv','/usr/bin/pip3') do
    it { should be_installed }
end

describe pip('flask','/usr/bin/pip3') do
    it { should be_installed }
end

describe pip('jinja2','/usr/bin/pip3') do
    it { should be_installed }
end

describe pip('Flask-And-Redis','/usr/bin/pip3') do
    it { should be_installed }
end

describe user('flask') do
    it { should exist }
    its('group') { should eq 'flask' }
    its('home') { should eq '/home/flask' }
end

describe file('/home/flask/flask-website') do
    it { should exist }
    its('type') { should eq :directory }
    it { should be_directory }
end

describe file('/home/flask/flask-website/project.py') do
    it { should exist }
end