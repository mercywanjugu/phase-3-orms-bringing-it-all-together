

class Dog
    #this will pass the first attr test!

   attr_accessor :name, :breed, :id

   def initialize (name:, breed:, id: nil)
    @id = id
    @name = name
    @breed = breed
   end
   #this will pass the .create_table test!
   def self.create_table
    sql = <<-SQL
     CREATE TABLE IF NOT EXISTS dogs(
         id INTEGER PRIMARY KEY,
         name TEXT,
         breed TEXT
        )
    SQL
    DB[:conn].execute(sql)
   end
    #this will pass the .drop_table test!
    def self.drop_table
        sql = "DROP TABLE IF EXISTS dogs"
        DB[:conn].execute(sql)
       end
       #this will pass the #save test!
   def save
    if self.id
        self.update
    else
        sql = <<-SQL
         INSERT INTO dogs (name, breed)
         VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.breed)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
     self
  end
   #this will pass the .create test!
   def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
  end

  #this will pass the .new_from_db test!
  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
  end
#this will pass the .all test!
def self.all
    sql = <<-SQL
      SELECT *
      FROM dogs;
    SQL

    DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
    end
  end
  #this will pass the .find_by_name test!
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE dogs.name = ?
      LIMIT 1;
    SQL

    DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
    end.first
  end
  #this will pass the .find test!
  def self.find(id)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE dogs.id = ?
      LIMIT 1;
    SQL

    DB[:conn].execute(sql, id).map do |row|
        self.new_from_db(row)
    end.first
  end
end
