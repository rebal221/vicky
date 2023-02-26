import Styled from "./styles";
import Image from 'next/image'
import 'react-phone-number-input/style.css'
import PhoneInput from 'react-phone-number-input'
import React, { useRef, useState, useEffect } from "react"; 
import Loading from "components/molecules/loading"; 
import { getAuth, PhoneAuthProvider, RecaptchaVerifier, signInWithCredential } from 'firebase/auth'; 
import { StyledLoading } from "../profile/styles"; 
import firebase from 'firebase/app';
import app from 'config/firebase.config'
import 'firebase/auth';
interface StepProps {
    function: Function,
    step?: string
    country?: String
}
declare global {
    interface Window {
        recaptchaVerifier: any;
        confirmationResult: any;
    }
}
// const auth = getAuth(app);
export default function Step(props: StepProps) {
    // 3 -> personal 4->Business
    const selectImageRef = useRef<HTMLInputElement>(null)
    const selectCvRef = useRef<HTMLInputElement>(null)
    const selectCoverImageRef = useRef<HTMLInputElement>(null)
    function validateEmail(email: String) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(email).toLowerCase());
    }
    function validatePhone(phone: String) {
        if (phone.length < 10 || phone.length > 15) {
            return false;
        }
        if (phone.substring(0, 4) === '+963') {
            return 'syria';
        }
        else {
            return true;
        }
    }
    useEffect(() => {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
        };
        fetch('http://localhost:8000/api/getmajor', requestOptions)
            .then(response => response.json())
            .then(data => {
                setMajors(data['majors'])
                setbusinessType(data['businessmajor'])
                setLoaded(true)
            })
            .catch(error => {
                console.error(error);
            });
    }, []);
    function get_worktype(id: String) {
        const type = acoountType == '3' ? 'getworktype' : 'getworktypebusiness'
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
            body: JSON.stringify({ 'major_id': id })
        };
        fetch('http://localhost:8000/api/' + type, requestOptions)
            .then(response => response.json())
            .then(data => {
                setWorktypes(data['data'])
            })
            .catch(error => {
                console.error(error);
            });
    }
    function get_contry() {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
        };
        fetch('http://localhost:8000/api/getconutries', requestOptions)
            .then(response => response.json())
            .then(data => {
                setCountries(data['data'])
            })
            .catch(error => {
                console.error(error);
            });

    }
    function get_Cities(id: String) {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
            body: JSON.stringify({ 'country_id': id })
        };
        fetch('http://localhost:8000/api/getcities', requestOptions)
            .then(response => response.json())
            .then(data => {
                setCities(data['data'])
            })
            .catch(error => {
                console.error(error);
            });
    }
    function get_Areas(id: String) {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
            body: JSON.stringify({ 'city_id': id })
        };
        fetch('http://localhost:8000/api/getareas', requestOptions)
            .then(response => response.json())
            .then(data => {
                setAreas(data['data'])
            })
            .catch(error => {
                console.error(error);
            });
    }
    function get_Experiences() {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
        };
        fetch('http://localhost:8000/api/getexperiences', requestOptions)
            .then(response => response.json())
            .then(data => {
                setExperiences(data['data'])
            })
            .catch(error => {
                console.error(error);
            });
    }
    function get_Certificates() {
        const requestOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
        };
        fetch('http://localhost:8000/api/getcertificates', requestOptions)
            .then(response => response.json())
            .then(data => {
                setCertificates(data['data'])
            })
            .catch(error => {
                console.error(error);
            });
    }
    const [majors, setMajors] = useState<any>();
    const [businessType, setbusinessType] = useState<any>();
    const [worktypes, setWorktypes] = useState<any>();
    const [countries, setCountries] = useState<any>();
    const [cities, setCities] = useState<any>();
    const [areas, setAreas] = useState<any>();
    const [Experiences, setExperiences] = useState<any>();
    const [Certificates, setCertificates] = useState<any>();
    const [active, setActive] = useState(false);
    const [otp, setotp] = useState('');
    const [show, setshow] = useState(false);
    const [final, setfinal] = useState<any>();
    var testphone;
    const [phone, setPhone] = useState<string>('');
    const [value, setValue] = useState()
    const [char1, setChar1] = useState<string>('');
    const [char2, setChar2] = useState<string>('');
    const [char3, setChar3] = useState<string>('');
    const [char4, setChar4] = useState<string>('');
    const [char5, setChar5] = useState<string>('');
    const [char6, setChar6] = useState<string>('');
    const [signUpMethod, setSignUpMethod] = useState<string>('email');
    const [email, setEmail] = useState<string>('');
    const inputRef1 = useRef<HTMLInputElement>(null);
    const inputRef2 = useRef<HTMLInputElement>(null);
    const inputRef3 = useRef<HTMLInputElement>(null);
    const inputRef4 = useRef<HTMLInputElement>(null);
    const inputRef5 = useRef<HTMLInputElement>(null);
    const inputRef6 = useRef<HTMLInputElement>(null);
    function handleInput(e: any, inputRef: any) {
        const value = e.target.value;
        const isNumber = /^[0-9]+$/.test(value);
        const nextInput = inputRef.current.nextElementSibling;
        if (nextInput) {
            if (isNumber) {
                // Move focus to the next input field
                inputRef.current.nextElementSibling.focus();
            }
        }

    }
    setTimeout(() => {
        setshow(false);
    }, 5000);
    const [firstname, setFirstname] = useState<string>('');
    const [password, setPassword] = useState<string>('');
    const [confirm, setConfirm] = useState<string>('');
    const [Website, setWebsite] = useState<string>('');
    const [preview, setPreview] = useState<any>();
    const [cvLink, setCvLink] = useState<any>();
    const [image, setImage] = useState<string>('');
    const [coverPreview, setCoverPreview] = useState<any>();
    const [coverImage, setCoverImage] = useState<string>('');
    const [loading, setLoading] = useState(false);
    const [univ, setUniv] = useState<string>('');
    const [acoountType, setAccountType] = useState<string>('');
    const [massege, setmassege] = useState<string>('');
    const [gender, setGender] = useState<string>('');
    const [decs, setDecs] = useState<string>('');
    const [country, setCountry] = useState<{ name: string, id: String }>({ name: '', id: '' });

    const [major, setMajor] = useState<{ name: string, id: String }>({ name: '', id: '' });
    const [businessmajor, setBusinessmajor] = useState<{ name: string, id: String }>({ name: '', id: '' });
    const [workType, setWorkType] = useState<{ name: string, id: String }>({ name: '', id: '' });
    const [city, setCity] = useState<{ name: string, id: String }>({ name: '', id: '' });
    const [Exper, setExper] = useState<{ name: string, id: String }>({ name: '', id: '' });
    const [area, setArea] = useState<{ name: string, id: String }>({ name: '', id: '' });
    const [certificate, setCertificate] = useState<{ name: string, id: String }>({ name: '', id: '' }); 


    const [cv, setCV] = useState<any>();



    const confirmPassword = (e: any) => {
        if (password && password != '') {
            if (password == e.target.value) {
                setConfirm(e.target.value);
            }
            else {
                setConfirm('')
            }
        }
    }

    const uploadImage = (e: any) => {
        setPreview(URL.createObjectURL(e.target.files[0]))
        setImage(e.target.files[0])
    }
    function uploadCv(e: any) {
        setCvLink(URL.createObjectURL(e.target.files[0]))
        setCV(e.target.files[0])
    }
    const [fileName, setFileName] = useState("");
    const uploadCoverImage = (e: any) => {
        setCoverPreview(URL.createObjectURL(e.target.files[0]))
        setCoverImage(e.target.files[0])
    } 
    const auth = getAuth(app);
    const phoneNumber = phone;
    const [verificationId, setVerificationId] = useState('');
    const [errorMessage, setErrorMessage] = useState('');
    
    const signInWithPhone = async () => {
      try {
        const applicationVerifier = new RecaptchaVerifier(
          'recaptcha-container',
          {
            size: 'normal',//invisible
          },
          auth,
        );
    
        const provider = new PhoneAuthProvider(auth);
        const vId = await provider.verifyPhoneNumber(phoneNumber, applicationVerifier);
    
        setVerificationId(vId);
        props.function('verify', phone, 'syria')
      } catch (error) {
        setErrorMessage('error');
      }
    };
    
    const verify = async (code: string) => {
        try {
            const authCredential = PhoneAuthProvider.credential(verificationId, code.toString());
            const userCredential = await signInWithCredential(auth, authCredential);
            console.log('verify: ', userCredential);
            props.function('checkotp','true')
          } catch (error) {
            props.function('email')
            console.log('verify error:', error);
          }
    };  
    const data = {
        firstname: firstname,
        confirm: confirm,
        password: password,
        major: major.name,
        image: image,
        role_id: acoountType,
        coverImage: coverImage,
        gender: gender == '1' ? 'Male' : 'Female',
        workType: workType.name,
        years: Exper.name,
        country: country.name,
        city: city.name,
        area: area.name,
        cv: cv,
        phone: phone,
        email: email,
        active: active,
        describebusiness: decs,
        website: Website,
        certificate: certificate.name,
        univ: univ
    }
    
    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
        body: JSON.stringify(data)
    };
    const submit = () => {
        fetch(`http://localhost:8000/api/savepersonal`, requestOptions)
            .then(response => response.json())
            .then((res) => {
                if (res.status) {
                    props.function('done')
                    sessionStorage.setItem("user_email", email);
                    sessionStorage.setItem("logedin", 'true');
                    window.location.href = '/profile-page?email=' + res['data'];
                }
                else {
                    console.log(res);
                }
            })
    }
    const selectImage = () => {
        selectImageRef.current?.click();
    }
    const selectCoverImage = () => {
        selectCoverImageRef.current?.click();
    }
    const [isLoaded, setLoaded] = useState(false);
    if (!isLoaded) {
        return (<StyledLoading >
            <div className="loading-div">
                <Loading />
            </div>

        </StyledLoading>)

    }
    return (
        <Styled className="absolute card" xs={24} lg={14} style={{ justifyContent: 'center' }}>
            <h1 className="font-size-42">
                Sign Up
            </h1>
            <div className="loading-div">
                {loading && <Loading />}
            </div>
            {show && (
                <div className="snackbar-container show">
                    <div className="snackbar">
                        {massege}
                    </div>
                </div>
            )}
            {props.step == 'email' &&
                <>
                    <div className="phoneEmail">
                        <div className="form-group-redio">
                            <div className="form-group d-flex align-items-center" style={{ flexDirection: 'row', justifyContent: 'center' }}>
                                <input type="radio" name="signUpMethod" value="email" onChange={() => setSignUpMethod('email')} checked={signUpMethod === 'email' ? true : false} />
                                <span className="ml-3">Email</span>
                            </div>
                            <div className="form-group d-flex align-items-center" style={{ flexDirection: 'row', justifyContent: 'center' }}>
                                <input type="radio" name="signUpMethod" value="phone" onChange={() => setSignUpMethod('phone')} />
                                <span className="ml-3">Phone</span>
                            </div>
                        </div>
                        {signUpMethod === 'email' &&
                            <div className="form-group" style={{ width: '60%' }}>
                                <input className="form-control" placeholder="Enter your email" value={email} type="text" onChange={(e) => { setEmail(e.target.value) }} />
                            </div>
                        }
                        {signUpMethod === 'phone' &&
                            <div className="form-group" style={{ width: '60%' }}>
                                <div className="form-group d-flex phone-style" style={{ width: '100%' }}>

                                    <PhoneInput
                                        placeholder="Enter phone number"
                                        value={value}
                                        onChange={e => {

                                            setPhone(e ? e : '')
                                        }} />
                                </div>
                                <div id="recaptcha-container"></div>
                            </div>
                        }
                        <div className="form-group" style={{ width: '60%' }} >
                            <button className="blue-submit" onClick={() => {
                                testphone = validatePhone(phone)
                                if (signUpMethod === 'email' && validateEmail(email)) {
                                    props.function('verify', email, 'email')
                                } else if (signUpMethod === 'phone' && testphone.toString() == 'true') {
                                    signInWithPhone() 
                                    // props.function('verify', phone, 'noun')
                                }
                                else if (signUpMethod === 'phone' && testphone.toString() == 'syria') {
                                    // props.function('verify', phone, 'syria')
                                    signInWithPhone() 
                                }
                            }}>Send Verification Code</button>
                        </div>

                        <span className="font-size-17 color-blue-1">
                            already have an account?<a style={{ color: 'var(--blue-3)' }} href="/sign-in"><span className="font-weight-bold ml-3 font-size-20">Sign In</span></a>
                        </span>
                    </div>
                </>
            }
            {props.step == 'verify' &&
                <>
                    <div className="form-group">
                        <div className="flex justify-around align-center w-full">
                            <input className="gray-input" ref={inputRef1} onInput={(e) => handleInput(e, inputRef1)} onChange={(e) => { setChar1(e.target.value) }} />
                            <input className="gray-input" ref={inputRef2} onInput={(e) => handleInput(e, inputRef2)} onChange={(e) => { setChar2(e.target.value) }} />
                            <input className="gray-input" ref={inputRef3} onInput={(e) => handleInput(e, inputRef3)} onChange={(e) => { setChar3(e.target.value) }} />
                            <input className="gray-input" ref={inputRef4} onInput={(e) => handleInput(e, inputRef4)} onChange={(e) => { setChar4(e.target.value) }} />
                            <input className="gray-input" ref={inputRef5} onInput={(e) => handleInput(e, inputRef5)} onChange={(e) => { setChar5(e.target.value) }} />
                            <input className="gray-input" ref={inputRef6} onInput={(e) => handleInput(e, inputRef6)} onChange={(e) => { 
                                setChar6(e.target.value)  
                             }} />
                                
                        </div>
                        <div className="resendMail">
                            <p>If the code not sent please click </p><button className="resendButton" onClick={() => props.function('resendMail')}>Here</button>
                        </div>
                    </div>

                    {signUpMethod === 'phone' &&
                        <div className="form-group">

                            <button onClick={() => { 
                                setotp(`${char1}${char2}${char3}${char4}${char5}${char6}`) 
                                verify(`${char1}${char2}${char3}${char4}${char5}${char6}`)
                            }} className="blue-submit-confirm">Confirm</button>
                        </div>
                    }
                    {signUpMethod === 'email' &&
                        <div className="form-group">
                            <button onClick={() => props.function('checkotp', `${char1}${char2}${char3}${char4}${char5}${char6}`)} className="blue-submit-confirm">Confirm code</button>
                        </div>
                    }
                </>
            }
            {props.step == 'accountType' || props.step == 'checkUser' || props.step == 'checkotp' &&
                <>
                    <div className="form-group" style={{ marginTop: '5%' }}>
                        <button className="yellow-submit-confirm" onClick={() => {
                            props.function('personal')
                            setActive(true)
                            setAccountType('3');
                        }}>Sign Up As A Personal Account</button>
                        <button className="blue-submit-confirm mt-10" onClick={() => {
                            props.function('personal')
                            setActive(true)
                            setAccountType('4');
                        }}>Sign Up As A Business Account</button>
                    </div>
                    <span className="font-size-17 color-blue-1">
                        already have an account? <span className="font-weight-bold ml-3 font-size-20">Sign In</span>
                    </span>
                </>
            }
            {props.step == 'personal' &&
                <>
                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Full Name</label>
                        <input className="form-control" type="text" value={firstname} onChange={(e) => { setFirstname(e.target.value) }} />
                    </div>
                    {signUpMethod === 'email' &&
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Phone number</label>
                            <input className="form-control" type="text" value={phone} onChange={(e) => { setPhone(e.target.value) }} />
                        </div>
                    }
                    {signUpMethod === 'phone' &&
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Email</label>
                            <input className="form-control" type="text" value={email} onChange={(e) => { setEmail(e.target.value) }} />
                        </div>
                    }
                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Password</label>
                        <input className="form-control" type="password" onChange={(e) => { setPassword(e.target.value) }} />
                    </div>
                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Confirm Password</label>
                        <input className="form-control" type="password" onChange={(e) => { setConfirm(e.target.value) }} />
                    </div>

                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Major</label>
                        {acoountType == '3' && <>
                            <select className="form-control-select" value={major.id.toString()} onChange={(e) => {
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                setMajor({ id: selectedOption.value, name: selectedOption.text });
                                get_worktype(selectedIndex.toString());
                                get_contry();
                                get_Experiences();
                                get_Certificates();
                            }}>
                                <option>Account Type</option>
                                {majors.map((major: any) => (
                                    <option key={major.id} value={major.id}>
                                        {major.name}
                                    </option>
                                ))}
                            </select>
                        </>}
                        {acoountType == '4' && <>
                            <select className="form-control-select" value={businessmajor.id.toString()} onChange={(e) => {
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                setBusinessmajor({ id: selectedOption.value, name: selectedOption.text });
                                setMajor({ id: selectedOption.value, name: selectedOption.text });
                                get_worktype(selectedOption.value.toString());
                                get_contry();
                                get_Experiences();
                            }}>
                                <option>Account Type</option>
                                {businessType.map((major: any) => (
                                    <option key={major.id} value={major.id}>
                                        {major.name}
                                    </option>
                                ))}
                            </select>
                        </>}
                    </div>
                    <div className="form-group">
                        <button className="blue-submit-confirm mt-10" onClick={() => {
                            if (major.id === '' || major.name === '') {
                                alert('Please select a major');
                            } else {
                                props.function('image', password, confirm)
                            }

                        }}>Next</button>
                    </div>
                </>
            }
            {props.step == 'image' &&
                <>
                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Choose Profile Picture</label>
                        <div className="upload">
                            <div className="image-wrapper">
                                <div className="d-block">
                                    <Image src={`${preview ? preview : '/images/photo.png'}`} alt="photo" onClick={selectImage} width={60} height={60} layout="responsive"></Image>
                                    <input type="file" onChange={(e) => { uploadImage(e) }} className="hidden" ref={selectImageRef} name="" id="selectImage" />
                                </div>
                                <div className="abs">
                                    <div className="d-block-2">
                                        <Image src="/images/camera.png" alt="photo" width={10} height={9} layout="responsive"></Image>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Choose Cover Picture</label>
                        <input type="file" onChange={(e) => { uploadCoverImage(e) }} className="hidden" ref={selectCoverImageRef} name="" id="selectImage" />
                        <div className="gray-upload" onClick={selectCoverImage} style={{ background: coverImage ? 'url(' + coverPreview + ')' : '#eee' }}>
                            <div className="cover-image">
                                <Image src="/images/camera.png" alt="photo" width={30} height={28} layout="responsive"></Image>
                            </div>
                        </div>
                    </div>
                    <div className="form-group">
                        <div className="flex-row">
                            <button className="blue-submit-confirm w-260" onClick={() => props.function('personal')}>Back</button>
                            <button className="blue-submit-confirm w-260" onClick={() => props.function('certificate')}>Next</button>
                        </div>
                    </div>
                </>
            }

            {props.step == 'certificate' &&
                <>
                    {acoountType == '3' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Certificate</label>
                            <select className="form-control-select" value={certificate.id.toString()} onChange={(e) => {
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                setCertificate({ id: selectedOption.value, name: selectedOption.text });
                            }}>
                                <option>Select certificate</option>
                                {Certificates.map((certificate: any) => (
                                    <option key={certificate.id} value={certificate.id}>
                                        {certificate.name}
                                    </option>
                                ))}
                            </select>
                        </div></>}
                    {acoountType == '3' &&
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">University Name</label>
                            <input className="form-control" type="text" value={univ} onChange={(e) => { setUniv(e.target.value) }} />
                        </div>
                    }
                    {acoountType == '4' &&
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Website</label>
                            <input className="form-control" type="text" value={univ} onChange={(e) => { setWebsite(e.target.value) }} />
                        </div>
                    }


                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Employment Type</label>
                        {worktypes && <>
                            <select className="form-control-select" value={workType.id.toString()} onChange={(e) => {
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                setWorkType({ id: selectedOption.value, name: selectedOption.text });

                            }}>
                                <option>Select Type</option>
                                {worktypes.map((work: any) => (
                                    <option key={work.id} value={work.id}>
                                        {work.name}
                                    </option>
                                ))}
                            </select>
                        </>
                        }
                    </div>
                    {acoountType == '4' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Years Experience</label>

                            <select className="form-control-select" value={Exper.id.toString()}
                                onChange={(e) => {
                                    const selectedIndex = e.target.selectedIndex;
                                    const selectedOption = e.target.options[selectedIndex];
                                    setExper({ id: selectedOption.value, name: selectedOption.text });
                                }} >
                                <option value="">
                                    Select
                                </option>
                                {Experiences.map((ex: any) => (
                                    <option key={ex.id} value={ex.id}>
                                        {ex.name}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </>}
                    {acoountType == '4' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Country</label>
                            {countries && <> <select className="form-control-select" value={country.id.toString()} onChange={(e) => {
                                //  setYears(e.target.value)
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                get_Cities(selectedOption.value);
                                setCountry({ id: selectedOption.value, name: selectedOption.text });
                            }} >
                                <option>Select Country</option>
                                {countries.map((country: any) => (
                                    <option key={country.id} value={country.id}>
                                        {country.name}
                                    </option>
                                ))}

                            </select></>}
                        </div>
                    </>}
                    <div className="form-group">
                        <div className="flex-row">
                            <button className="blue-submit-confirm w-260" onClick={() => {
                                props.function('image')
                            }
                            }>Back</button>
                            <button className="blue-submit-confirm w-260" onClick={() => {
                                acoountType == '3' ? props.function('gender') : props.function('country')
                            }}>Next</button>
                        </div>
                    </div>

                </>
            }
            {props.step == 'gender' &&
                <>
                    {acoountType == '3' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Gender</label>
                            <select className="form-control-select" onChange={(e) => { setGender(e.target.value) }} >
                                <option value="">
                                    Select gender
                                </option>
                                <option value="1">
                                    Male
                                </option>
                                <option value="2">
                                    Female
                                </option>
                            </select>
                        </div></>}
                    {acoountType == '3' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Years Experience</label>

                            <select className="form-control-select" value={Exper.id.toString()}
                                onChange={(e) => {
                                    const selectedIndex = e.target.selectedIndex;
                                    const selectedOption = e.target.options[selectedIndex];
                                    setExper({ id: selectedOption.value, name: selectedOption.text });
                                }} >
                                <option value="">
                                    Select
                                </option>
                                {Experiences.map((ex: any) => (
                                    <option key={ex.id} value={ex.id}>
                                        {ex.name}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </>}
                    {acoountType == '3' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Country</label>
                            {countries && <> <select className="form-control-select" value={country.id.toString()} onChange={(e) => {
                                //  setYears(e.target.value)
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                get_Cities(selectedOption.value);
                                setCountry({ id: selectedOption.value, name: selectedOption.text });
                            }} >
                                <option>Select Country</option>
                                {countries.map((country: any) => (
                                    <option key={country.id} value={country.id}>
                                        {country.name}
                                    </option>
                                ))}

                            </select></>}
                        </div>
                    </>}

                    <div className="form-group">
                        <div className="flex-row">
                            <button className="blue-submit-confirm w-260" onClick={() => props.function('certificate')}>Back</button>
                            <button className="blue-submit-confirm w-260" onClick={() => props.function('country')}>Next</button>
                        </div>
                    </div>
                </>
            }

            {props.step == 'country' &&
                <>
                    {cities && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">city</label>
                            <select className="form-control-select" value={city.id.toString()} onChange={(e) => {
                                // setGender(e.target.value) 
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                setCity({ id: selectedOption.value, name: selectedOption.text });
                                get_Areas(selectedOption.value);
                            }} >
                                <option value="">
                                    Select city
                                </option>
                                {cities.map((city: any) => (
                                    <option key={city.id} value={city.id}>
                                        {city.name}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </>}

                    {areas && cities && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Area</label>
                            <select className="form-control-select" value={area.id.toString()} onChange={(e) => {
                                // setGender(e.target.value) 
                                const selectedIndex = e.target.selectedIndex;
                                const selectedOption = e.target.options[selectedIndex];
                                setArea({ id: selectedOption.value, name: selectedOption.text });
                            }} >
                                <option value="">
                                    Select Area
                                </option>
                                {areas.map((area: any) => (
                                    <option key={area.id} value={area.id}>
                                        {area.name}
                                    </option>
                                ))}
                            </select>
                        </div>
                    </>
                    }
                    {acoountType == '4' && <>
                        <div className="form-group">
                            <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Describe your business</label>
                            <div className="business_desc">
                                <textarea name="message"
                                    className="business_text"
                                    placeholder={'Enter your description here ...'}
                                    onChange={(e) => { setDecs(e.target.value) }}>
                                </textarea>
                            </div>
                        </div>
                    </>}
                    <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">
                            Upload Attachment
                        </label>
                        <div className="uploadCv">
                            <p>{cvLink ? cvLink : "Upload Attachment"}</p>
                            <div className="uplad-content">
                                <input type="file"
                                    onChange={(e) => { uploadCv(e) }}
                                    className="hidden upladinput" ref={selectCoverImageRef}
                                    name="" id="" accept=".pdf" />
                                <img
                                    src="/images/upload.png"
                                    alt="upload"
                                    style={{ width: "90%" }}
                                    onChange={() => { }}
                                />
                            </div>
                        </div>
                    </div>
                    {/* <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Country</label>
                        <select className="form-control-select" onChange={(e) => { setCountry(e.target.value) }} >
                            <option value="">
                                Select Country
                            </option>
                            <option value="">
                                Syria
                            </option>
                        </select>
                    </div> */}
                    {/* <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">City</label>
                        <select className="form-control-select" onChange={(e) => { setCity(e.target.value) }} >
                            <option value="">
                                Select City
                            </option>
                            <option value="1">
                                Damascus
                            </option>
                        </select>
                    </div> */}
                    {/* <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Area</label>
                        <select className="form-control-select" onChange={(e) => { setArea(e.target.value) }} >
                            <option value="">
                                Select Area
                            </option>
                            <option value="1">
                                Mazzah
                            </option>
                        </select>
                    </div> */}
                    {/* <div className="form-group">
                        <label className="color-blue-1 font-weight-bold mb-3" htmlFor="">Upload CV</label>
                        <input type="file" name="" id="" onChange={(e) => { selectCV(e) }} />
                    </div> */}
                    <div className="form-group">
                        <button className="blue-submit-confirm" onClick={submit}>SignUp</button>
                    </div>
                </>
            }
            <script src="https://www.google.com/recaptcha/api.js"></script>
        </Styled>


    );
}
