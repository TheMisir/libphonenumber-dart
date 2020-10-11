#![allow(clippy::missing_safety_doc)]

extern crate phonenumber;

use phonenumber::{Mode, PhoneNumber};
use std::{
	ffi::{CStr, CString, NulError},
	os::raw::c_char,
	str::Utf8Error,
};

//////////////////////////////////////////////////////////////////////////////////////////
///////////////// Utils
//////////////////////////////////////////////////////////////////////////////////////////

pub fn from_c_str<'a>(str: *const c_char) -> Result<&'a str, Utf8Error> {
	unsafe { CStr::from_ptr(str) }.to_str()
}

pub fn to_c_str(str: &str) -> Result<CString, NulError> {
	CString::new(str.as_bytes())
}

pub fn parse_mode(mode: u8) -> Result<Mode, ()> {
	match mode {
		0 => Ok(Mode::E164),
		1 => Ok(Mode::International),
		2 => Ok(Mode::National),
		3 => Ok(Mode::Rfc3966),
		_ => Err(()),
	}
}

pub fn to_u8(val: bool) -> u8 {
	match val {
		true => 1,
		false => 0,
	}
}

//////////////////////////////////////////////////////////////////////////////////////////
///////////////// Externs
//////////////////////////////////////////////////////////////////////////////////////////

#[no_mangle]
pub extern "C" fn phonenumber_format(number: *const PhoneNumber, mode: u8) -> *const c_char {
	let number = unsafe { &*number };
	let formatter = phonenumber::format(number);
	let result = format!("{}", formatter.mode(parse_mode(mode).unwrap()));
	to_c_str(&result).unwrap().as_ptr()
}

#[no_mangle]
pub extern "C" fn phonenumber_is_valid(number: *const PhoneNumber) -> u8 {
	let number = unsafe { &*number };
	to_u8(phonenumber::is_valid(number))
}

#[no_mangle]
pub extern "C" fn phonenumber_is_viable(input: *const c_char) -> u8 {
	let input = from_c_str(input).unwrap();
	to_u8(phonenumber::is_viable(input))
}

#[no_mangle]
pub extern "C" fn phonenumber_parse(
	number: *mut *const PhoneNumber,
	country: *const c_char,
	input: *const c_char,
) -> u8 {
	let country = from_c_str(country).unwrap();
	let input = from_c_str(input).unwrap();
	phonenumber::parse(Some(country.parse().unwrap()), input)
		.and_then(|new_number| {
			let number_ptr = Box::into_raw(Box::new(new_number));
			unsafe { number.write(number_ptr) };
			Ok(0)
		})
		.unwrap_or(1)
}

#[no_mangle]
pub extern "C" fn phonenumber_print(number: *const PhoneNumber) {
	let number = unsafe { &*number };
	let valid = phonenumber::is_valid(number);

	if valid {
		println!("\x1b[32m{:#?}\x1b[0m", number);
		println!();
		println!(
			"International: {}",
			number.format().mode(Mode::International)
		);
		println!("     National: {}", number.format().mode(Mode::National));
		println!("      RFC3966: {}", number.format().mode(Mode::Rfc3966));
		println!("        E.164: {}", number.format().mode(Mode::E164));
	} else {
		println!("\x1b[31m{:#?}\x1b[0m", number);
	}
}
