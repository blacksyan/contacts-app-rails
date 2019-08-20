module ContactsHelper
    def fetch_contacts_redis(user)
        contacts = $redis.get("contacts")
        if contacts.nil?
            contacts = user.contacts.to_json   
            $redis.set("contacts",contacts)
            $redis.expire("contacts",5.hour.to_i)
        end
        JSON.load contacts
    end
end
