module Badgeable
  module Award
    # Configure a class to automatically award badges after creation.
    # Assign a badge name and a block with configuration
    # directives.
    # 
    # Valid directives:
    # 
    # thing        (Required) a class constant in this namespace that 
    #              awards the badge.
    # subject      (Optional, default = :user) a symbol that references
    #              the object to which the badge is awarded. This should
    #              be a related object that includes Badgeable, and will
    #              usually have referenced_in :thing, belongs_to :thing etc.
    # count        (Optional, default = 1) either an integer threshold value
    #              of :things related to :subject, or a block. If a block
    #              is given, the created instance of :thing is passed as
    #              the first block argument, and the block must return
    #              return true for the badge to be awarded.
    # conditions   (Optional) provide a block; if your block returns 
    #              returns true, the badge is awarded. The first block 
    #              argument is the created instance of :thing. The 
    #              conditions directive may be called any number of times,
    #              and all conditions and the count block must return true.
    #              Also note that the conditions and count directives are
    #              evaluated separately.
    # 
    # See README for usage examples
    # 
    def badge(name, options = {}, &block)
      #AK this is where the main action happens
      #AK badge method was called and the block after badge "gold medal" do
      #AK is passed in
      after_callback = options[:after] || :create
      
      config = Badgeable::Config.new #ak create a new config object
      config.instance_eval(&block) #ak pass in the block in badge
                                   #ak sets up the klass attribute, the subject_proc
                                   #ak all the main machinery which will be called later
      attrs = [:description, :icon].inject({}) {|hash, key| hash.merge(key => config.send(key)) }
      method_name = "award_#{name.titleize.gsub(/\s/, '').underscore}_badge".to_sym
      config.klass.class_eval do #ak creates an instance method!!! 
                                 #ak in class klass, which is the model specified in 
                                 #ak thing Model
        set_callback after_callback, :after, method_name
        define_method method_name, Proc.new { 
          # print self
          # print 'monkey'
          # print config.conditions_array[1].call(self)
          if config.conditions_array.all? {|p| p.call(self) } #ak calls each condition
                                                              #ak first is always true line 11 of config
                                                              #ak second is count block
                                                              #ak next are the conditions block
                                                              
            print 'here'
            config.subject_proc.call(self).award_badge(name, attrs)
          end
        }
      end
    end
  end
end