extern crate phonenumber;

use phonenumber::Mode;
use phonenumber::country::Id;

#[no_mangle]
pub extern fn lib_test() {
    println!("Hello from the library!");
}

#[no_mangle]
pub extern fn hello_world() {

	let number = phonenumber::parse(Some(Id::AZ), "+994516125433").unwrap();
	let valid  = phonenumber::is_valid(&number);

	if valid {
		println!("\x1b[32m{:#?}\x1b[0m", number);
		println!();
		println!("International: {}", number.format().mode(Mode::International));
		println!("     National: {}", number.format().mode(Mode::National));
		println!("      RFC3966: {}", number.format().mode(Mode::Rfc3966));
		println!("        E.164: {}", number.format().mode(Mode::E164));
	}
	else {
		println!("\x1b[31m{:#?}\x1b[0m", number);
	}
}

