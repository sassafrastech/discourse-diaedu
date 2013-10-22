require 'pg'

namespace :diaedu do
  desc 'Imports suggestion/action data from modd database'
  task 'import_modd' => :environment do

    # wipe old stuff
    [Diaedu::GlyprobTrigger, Diaedu::TriggerGoal, Diaedu::Glyprob, Diaedu::Trigger, Diaedu::Goal, Diaedu::Event, Diaedu::Tagging, Diaedu::Tag].each(&:delete_all)

    # create tags
    tags = []
    tag_names = %w(brill cornicle phi menseless inkstand comedic cranky carolled laboriously predomestically calenturish oncoming registh atypically concepcin revulsion leonore expression egomania insouciant gallipot overglad unroaming hokiang bromism coastguardsman regina supereducation tangerine ferociousness unindulging weightlessly undaintily symons entreatingly bedfellow legaspi alienation proapproval overdemand macaber cupidity glamor indira unparried penile hematoblast livelihood unedged outequivocate machined unfreezable verbalist lot unhomogeneous nicolai fulvous autonomically insessorial microspectrophotometry oocyte nonsensitivity unomened voetstoets underpen malacologist wort symbolistic caxias leukemid hindostan afrit monocytic paul unsqueezed grandiloquently gloria hydroformylation executively appraisingly nonproportionate whitey chancing squillgeeing taegu cape brunner)
    (tag_names.size - tags.size).abs.times do |i|
      tags << Diaedu::Tag.create(:name => tag_names[i])
    end

    # connect to modd db
    conn = PGconn.connect("host=localhost dbname=modd user=postgres")

    # the only events are modd eventlets
    events = {}
    elets = [:on_wake_up, :before_bfast, :after_bfast, :before_lunch, :after_lunch, :before_dinner, :after_dinner, :on_bedtime, :on_night]
    elets.each do |elet|
      name = elet.to_s.gsub('on_', 'at_').gsub('bfast', 'breakfast').capitalize.gsub(/_(\w)/){" #{$1}".upcase}
      events[elet] = Diaedu::Event.create(:name => name)
      puts "Created event #{name}"
    end

    # glyprobs are all combinations of events with high/low (18 in total)
    glyprobs = {}
    events.each_pair do |elet, event|
      [:low, :high].each do |eval|
        glyprobs[[elet, eval]] = Diaedu::Glyprob::create(:evaluation => eval, :event => event, 
          :description => Random.paragraphs(1), :tags => get_tags(tags))
        puts "Created glyprob #{eval} #{event.name}"
      end
    end

    # import suggestions (triggers) and link to appropriate events
    # create hash of suggestion ids to triggers
    sugg_trig = {}
    trig_names = {}
    res = conn.exec('SELECT * FROM suggestions')
    res.each do |row|
      name = row['question_en']
      desc = row['reason_en']

      # check for duplicate names
      if trig_names[name]
        puts "Skipped duplicate trigger #{name}"
      else
        # determine glyprobs with which to assoc this trigger
        trigger_glyprobs = []
        eval = row['evaluation'].to_sym
        elets.each do |elet|
          trigger_glyprobs << glyprobs[[elet, eval]] if row[elet.to_s] == 't'
        end

        trigger = Diaedu::Trigger.create(:name => name, :description => desc, :glyprobs => trigger_glyprobs, :tags => get_tags(tags))
        puts "Created trigger #{name} with #{eval} and #{trigger.glyprobs.size} glyprobs"

        # save the name 
        trig_names[name] = true

        sugg_trig[row['id']] = trigger
      end
    end

    # import actions (goals)
    goal_names = {}
    res = conn.exec('SELECT * FROM actions')
    res.each do |row|
      name = row['short_description_en']
      desc = row['description_en']

      # check for duplicate names
      if goal_names[name]
        puts "Skipped duplicate goal #{name}"

      else
        # determine triggers with which to assoc this goal
        goal_triggers = []
        res2 = conn.exec("SELECT * FROM suggestion_actions WHERE action_id = #{row['id']}")
        res2.each do |row2|
          goal_triggers << sugg_trig[row2['suggestion_id']]
        end

        goal_names[name] = true

        goal_triggers.compact!

        goal = Diaedu::Goal.create(:name => name, :description => desc, :triggers => goal_triggers, :tags => get_tags(tags))
        puts "Created goal #{name} with #{goal.triggers.size} triggers"
      end
    end
  end

  # gets a random set of 0-2 tags from the given set of tags
  def get_tags(tags)
    # get number between 0 and 2, with 0 more likely
    n = [0, rand(5) - 2].max
    tags.shuffle[0...n]
  end
end