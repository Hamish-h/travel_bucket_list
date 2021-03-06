require_relative( '../db/sql_runner' )
# require('pry-byebug')
# binding.pry
class City

  attr_reader( :id, :country_id )
  attr_accessor( :name, :review )

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @review = options['review']
    @country_id = options['country_id']
  end

  def save()
    sql = "INSERT INTO cities
    (
      name, review, country_id
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@name, @review, @country_id]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def update()
    sql = "UPDATE cities
    SET
    (
      name, review, country_id
    ) =
    (
      $1, $2, $3
    )
    WHERE id = $4"
    values = [@name, @review, @country_id, @id]
    results = SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM cities
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM cities"
    results = SqlRunner.run( sql )
    return results.map { |hash| City.new( hash ) }
  end

  def self.find( id )
    sql = "SELECT * FROM cities
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return City.new( results.first )
  end

  def self.map_items(cities_data)
    return cities_data.map { |cities| Cities.new(cities) }
  end

  def format_name
    return "#{@name.capitalize}"
  end

  def self.delete_all
    sql = "DELETE FROM cities"
    SqlRunner.run( sql )
  end
end
