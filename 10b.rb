#!/usr/bin/ruby

class Evaluator
  def initialize()
    @bots = {}
    @instructions = {}
    @outputs = {}

    File.open('10.in').each do |x|
      i = x.split
      if i.first == 'value'
        # Bots are modeled as a hash identifying bot ID and an array of chips
        @bots[i[5].to_i] ||= []
        @bots[i[5].to_i] <<= i[1].to_i
      else
        # Instructions are modelled as a hash identifying bot ID, high and low operations
        @instructions[i[1].to_i] = {
          :low  => { :what => i[5].to_sym,  :where => i[6].to_i  },
          :high => { :what => i[10].to_sym, :where => i[11].to_i },
        }
      end
    end
  end

  def propagate(vals, inst, op)
    if inst[:what] == :bot
      @bots[inst[:where]] ||= []
      @bots[inst[:where]] <<= vals.send(op)
    else
      @outputs[inst[:where]] = vals.send(op)
    end
  end

  def evaluate
    # Find a bot ready to execute
    while bot = @bots.find{|x,y| y.length == 2}
      # Find the instruction for that bot
      i = @instructions[bot.first]
      propagate(bot.last, i[:low],  :min)
      propagate(bot.last, i[:high], :max)
      # Clear the chips out of the bot
      @bots[bot.first] = []
    end
  end

  def result
    @outputs.sort.take(3).map(&:last).reduce(:*)
  end
end

e = Evaluator.new
e.evaluate
puts e.result
