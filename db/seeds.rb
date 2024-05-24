c1 = Circuit.find_or_create_by(name: 'RS-111')
c2 = Circuit.find_or_create_by(name: 'RS-222')

c1.update(
  overseer_name: 'John Doe',
  overseer_phone_number: '51 99999-8888'
)

c2.update(
  overseer_name: 'James Doe',
  overseer_phone_number: '51 99999-7777'
)
