class Customer
  attr_accessor :name, :surname, :age, :code, :id

  def initialize(name:, surname:, age:, code:, id:)
    @name = name
    @surname = surname
    @age = age
    @code = code
    @id = id
  end

  def full_name
    "#{name} #{surname}"
  end

  def create
    $pg.exec_params(sql_insert, sql_insert_params)
  end

  def self.all(per_page = 10, page = 0)
    data_customers = $pg.exec("select * from customers order by id limit #{per_page} offset #{per_page * page}")
    data_customers.map do |data|
    Customer.new(name: data['name'], surname: data['surname'],
                  age: data['age'], code: data['code'], id: data['id'])
  end
  end

  def self.count 
    $pg.exec("select count(*) from customers").first['count'].to_i
  end

  def self.find(id)
    data = $pg.exec("select * from customers where id = #{id}").first
    Customer.new(name: data['name'], surname: data['surname'],
                age: data['age'], code: data['code'], id: data['id'])
  end

  def update(params = {})
    $pg.exec(sql_update_statement(params))

  end



  private

  def sql_update_statement(params)
    %{
      UPDATE customers SET
        name='#{params[:name]}',
        surname='#{params[:surname]}',
        code=#{params[:code]},
        age=#{params[:age]}
        WHERE id = #{params[:id]}
    }
  end

  def sql_insert
    "INSERT INTO customers(name, surname, age, code) VALUES($1,$2,$3,$4)"
  end

  def sql_insert_params
    [name, surname, age, code]
  end
end 