module Bitcourier
  class AddressArray < Array
    def include? address
      each do |a|
        return true if a.equals?(address)
      end

      return false
    end
  end
end
