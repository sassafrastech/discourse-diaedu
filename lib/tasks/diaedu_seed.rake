namespace :diaedu do
  desc 'Seeds diabetes educator knowledge base objects'
  task 'seed' => :environment do

    tags = Diaedu::Tag.all
    events = Diaedu::Event.all
    glyprobs = Diaedu::Glyprob.all
    triggers = Diaedu::Trigger.all
    goals = Diaedu::Goal.all

    tag_names = %w(brill cornicle phi menseless inkstand comedic cranky carolled laboriously predomestically calenturish oncoming registh atypically concepcin revulsion leonore expression egomania insouciant gallipot overglad unroaming hokiang bromism coastguardsman regina supereducation tangerine ferociousness unindulging weightlessly undaintily symons entreatingly bedfellow legaspi alienation proapproval overdemand macaber cupidity glamor indira unparried penile hematoblast livelihood unedged outequivocate machined unfreezable verbalist lot unhomogeneous nicolai fulvous autonomically insessorial microspectrophotometry oocyte nonsensitivity unomened voetstoets underpen malacologist wort symbolistic caxias leukemid hindostan afrit monocytic paul unsqueezed grandiloquently gloria hydroformylation executively appraisingly nonproportionate whitey chancing squillgeeing taegu cape brunner)

    (tag_names.size - tags.size).abs.times do |i|
      tags << Diaedu::Tag.create(:name => tag_names[i])
    end

    (events.size - 314).abs.times do
      events << (e = Diaedu::Event.create(:name => Random.phrase(4)))
      %w(high low).shuffle[0..rand(2)].each do |eval|
        glyprobs << Diaedu::Glyprob.create(:event => e, :evaluation => eval, :description => Random.paragraphs(1), :tags => get_tags(tags))
      end
    end

    (triggers.size - 270).abs.times do
      t = Diaedu::Trigger.new(:name => Random.phrase(10), :description => Random.paragraphs(1), :tags => get_tags(tags))

      # associate with a random set of glyprobs
      glyprobs.shuffle[0..rand(25)].each do |g|
        t.glyprob_triggers.build(:glyprob_id => g.id)
      end

      t.save!
      triggers << t
    end

    (goals.size - 194).abs.times do
      g = Diaedu::Goal.new(:name => Random.phrase(7), :description => Random.paragraphs(1), :tags => get_tags(tags))

      # associate with a random set of triggers
      triggers.shuffle[0..rand(18)].each do |t|
        g.trigger_goals.build(:trigger_id => t.id)
      end

      g.save!
      goals << g
    end

  end
end