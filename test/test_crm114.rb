$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'test/unit'
require 'crm114'

class TestCRM114 < Test::Unit::TestCase

  def setup
    @path = File.dirname(__FILE__)
    @crm = Classifier::CRM114.new([:interesting, :boring], :path => @path)
    assert_nothing_raised do
      @crm.train! :interesting, <<EOT
        Computational processes are abstract beings that inhabit computers.
        As they evolve, processes manipulate other abstract things called
        data. The evolution of a process is directed by a pattern of rules
        called a program. People create programs to direct processes. In
        effect, we conjure the spirits of the computer with our spells.
EOT
      @crm.train! :boring, <<EOT
        Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nam vitae
        nisi nec sapien congue porttitor. Proin quam risus, pharetra non,
        lacinia sed, vehicula non, eros. Suspendisse velit augue, aliquet
        vel, sagittis vitae, porttitor sed, metus. Integer tortor tellus,
        tempus tincidunt, viverra a, fringilla vitae, sapien. Ut ac eros.
        Donec molestie nulla sed nibh. Pellentesque quam quam, vehicula sed,
        venenatis vitae, tristique quis, lectus. Aenean odio purus, pharetra
        non, facilisis sed, rutrum eu, lectus. Curabitur odio. Ut laoreet
        dolor vitae nunc. Donec dapibus. Morbi tempor libero et dolor.
        Aliquam rutrum metus quis nibh. Ut pharetra turpis vel metus. Donec
        vel arcu. Sed neque orci, accumsan et, faucibus quis, porttitor in,
        lacus. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
        Phasellus et arcu. Mauris nunc.
EOT
    end
  end

  def teardown
    Dir["#{@path}/*.css"].each { |file| File.delete(file) }
  end

  def test_resolution_of_popen_conflict_with_net_http
    # make arbitrary Net:HTTP call
    require 'net/http'
    txt = Net::HTTP.get_response(URI.parse('http://www.google.com'))
    # something goes nuts and popen bombs; we switched to popen3 so this should work fine now
    assert_equal(:interesting, @crm.classify('Thus, programs must be written for people to read,').first)
  end

  def test_version
    assert_match(/^[\d]+-[\w\d]+$/, Classifier::CRM114.version)
  end

  def test_unlearning
    assert_raise(NotImplementedError) { @crm.unlearn!(:boring, 'Lorem ipsum') }
  end

  def test_interesting
    assert_equal(:interesting, @crm.classify('Thus, programs must be written for people to read,').first)
    assert_equal(true, @crm.interesting?('and only incidentally for machines to execute.'))
    assert_equal(false, @crm.boring?('learning to program is considerably less dangerous than learning sorcery'))
  end

  def test_boring
    assert_equal(:boring, @crm.classify('Lorem ipsum dolor sit amet, sed neque orci.').first)
    assert_equal(false, @crm.interesting?('Donec dapibus. Morbi tempor libero et dolor.'))
    assert_equal(true, @crm.boring?('Aliquam rutrum metus quis nibh. Ut pharetra turpis vel metus.'))
  end

end
