require_relative( '../db/sql_runner' )

class Country

  attr_reader( :id )
  attr_accessor ( :name )

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO countries
    (
      name
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@name]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

# brackets at SET for single value
  def update()
    sql = "UPDATE countries
    SET
      name
    =
      $1
    WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM countries
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM countries"
    results = SqlRunner.run( sql )
    return results.map { |hash| Country.new( hash ) }
  end

  def self.map_items(countries_data)
    return countries_data.map { |country| Country.new(country) }
  end

  def self.find( id )
    sql = "SELECT * FROM countries
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return Country.new( results.first )
  end

  def self.delete_all
    sql = "DELETE FROM countries"
    SqlRunner.run( sql )
  end
end
