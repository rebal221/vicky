import React, { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { Drawer, Row, Col, Switch } from 'antd';
import { useWindowSize } from 'components/functions/usewindowsize';
import NavMenu from '../../molecules/nav-menu';
import StyledHeader from './styles';
import { useTranslation } from 'react-i18next';
import _ from 'lodash';
import i18n from 'i18n';



function UserHeader() {
  const size = useWindowSize();
  const { t } = useTranslation();
  const [email, setEmail] = useState<any>();
  const [notifications, setNotificationsoffer] = useState([]);
  const [showNotifications, setShowNotifications] = useState(false);
  const [isshowPriceingServices, setshowPriceingServices] = useState(false);
  const [PriceingServicesoutbox, setPriceingServicesoutbox] = useState([]);
  const [PriceingServicesinbox, setPriceingServicesinbox] = useState<any>([]);
  const [req, setreq] = useState([]);
  const [user_id, setuser_id] = useState<any>();
  const [activeLanguage, setLang] = useState<any>()
  const [following, setFollowing] = useState()
  const [Followers, setFollowers] = useState()
  const [iservices, setiservices] = useState(false);
  const [loc, setloc] = useState<any>()
  const API_BASE_URL = 'http://localhost:8000/api/';


  useEffect(() => {
    setloc(window.location.href)
    setiservices(sessionStorage.getItem('priceing') === 'true' ? true : false)
    setLang(sessionStorage.getItem('lang'))
    i18n.changeLanguage(activeLanguage)
    setEmail(sessionStorage.getItem('user_email'));
    getUser()
    const intervalId = setInterval(() => {
      checkNotifications();
      getfollowing()
      checkservicesoutbox()
      checkservicesinbox()
      setiservices(sessionStorage.getItem('priceing') === 'true' ? true : false)
    }, 11000);

    return () => clearInterval(intervalId);
  }, [email, activeLanguage, req]);
  const stoppricing = () => {
    fetch(API_BASE_URL + 'activepricing', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
      body: JSON.stringify({ 'email': email })
    })
      .then(response => response.json())
      .then(data => {
        // console.log(data)
      })
      .catch(error => {
        console.error(error);
      });
  }
  const getUser = useCallback(() => {
    fetch(API_BASE_URL + 'getuserbyEmail', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'Accept': 'application/json' },
      body: JSON.stringify({ 'email': email })
    })
      .then(response => response.json())
      .then(data => {
        setuser_id(data[0]['id'])
      })
      .catch(error => {
        console.error(error);
      });
  }, [email]);
  const getfollowing = useCallback(async () => {
    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ 'email': email })
    };
    try {
      const response = await fetch(API_BASE_URL + 'getfollowing', requestOptions);
      const data = await response.json();
      setFollowing(data['data']['following'])
      setFollowers(data['data']['followers'])
    } catch (error) {
      console.error(error);
    }
  }, [email]);
  async function checkservicesoutbox() {
    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ 'email': email })
    };
    try {
      const response = await fetch(API_BASE_URL + 'checkServices', requestOptions);
      const data = await response.json();
      setPriceingServicesoutbox(data['data'])
    } catch (error) {
      console.error(error);
    }
  }
  async function checkservicesinbox() {
    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ 'email': email })
    };
    try {
      const response = await fetch(API_BASE_URL + 'checkservicesinbox', requestOptions);
      const data = await response.json();
      console.log(data);



      setreq(data)
      setPriceingServicesinbox(data)
    } catch (error) {
      console.error(error);
    }
  }

  async function checkNotifications() {
    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ 'email': email })
    };
    try {
      const response = await fetch(API_BASE_URL + 'checkNotifi', requestOptions);
      const data = await response.json();
      const offerNotifications = data.filter((notification: any) => notification.notification_type === 'offer');
      setNotificationsoffer(offerNotifications);
    } catch (error) {
      console.error(error);
    }
  }
  async function saveReplay(req_id: String) {
    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ 'user_id': user_id, 'req_id': req_id })
    };
    try {
      const response = await fetch(API_BASE_URL + 'saveReplay', requestOptions); 
    } catch (error) {
      console.error(error);
    }
  }
  async function readNotification(post_id: String, user_id: String) {
    const requestOptions = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ 'post_id': post_id, 'user_id': user_id })
    };

    try {
      const response = await fetch(API_BASE_URL + 'readNotification', requestOptions);
      const data = await response.json();
      setNotificationsoffer(data);
    } catch (error) {
      console.error(error);
    }
  }
  function handleNotificationsClick() {
    setShowNotifications(!showNotifications);
  }
  function handleServices() {
    console.log(PriceingServicesoutbox);

    setshowPriceingServices(!isshowPriceingServices)
  }
  const inboxByReqId = PriceingServicesinbox.reduce((acc: any, message:any) => {
    if (!acc[message['req_id']]) {
      acc[message['req_id']] = [];
    }
    acc[message['req_id']].push(message);
    return acc;
  }, {});

  return (
    <StyledHeader className="pt-6">
      <Row className='userheadContent'>
        <div className='userheadleftSide'>
          <p style={{ cursor: 'pointer' }}>({following}) {t('Following')}</p>
          <p style={{ cursor: 'pointer' }}>({Followers}) {t('Followers')}</p>
          {iservices && <><Switch checked={iservices} onChange={() => {
            setiservices(!iservices)
            sessionStorage.setItem('priceing', 'false')
            window.location.href = './pricing-service'
            stoppricing()
          }} /></>}
        </div>
        <div className='userheadrightSide'>
          <div className='user_profile-defult-gray-button' onClick={() => {
            checkservicesinbox()
          }}>
            <Image src={'/images/mail.png'}
              width={30}
              height={30}
            ></Image>
          </div>
          {loc != 'http://127.0.0.1:3000/profile-page' && <div className='user_profile-defult-gray-button' onClick={() => {
            window.location.href = './profile-page'
          }}>
            <Image src={'/images/user.png'}
              width={30}
              height={30}
            ></Image>
          </div>}
          <div className='user_profile-defult-gray-button'>
            <Image src={'/images/social-media-marketing.png'}
              width={30}
              height={30}
            ></Image>
          </div>
          <div className='user_header'>
            <div className='user_profile-defult-gray-button' onClick={handleServices}>
              {(PriceingServicesoutbox && PriceingServicesoutbox.length > 0) && (
                <>
                  <div className='notCon'>
                    {PriceingServicesoutbox.filter(service => service['user_id'] != user_id.toString()).length > 0 &&
                      <div className='notifi'>
                        {PriceingServicesoutbox.filter(service => service['user_id'] != user_id.toString()).length + (PriceingServicesinbox && PriceingServicesinbox.length)}
                      </div>
                    }
                  </div>
                </>
              )}
              <Image src={'/images/rich-icon.png'}
                width={30}
                height={30}
              ></Image>
            </div>
            {(isshowPriceingServices && (PriceingServicesoutbox || PriceingServicesinbox)) && (
              <div className='notification-dropdown'>
                <ul style={{ maxHeight: '15rem', width: '15rem', overflowX: 'auto' }}>
                  {PriceingServicesoutbox && <> {PriceingServicesoutbox.length > 0 && <>
                    {PriceingServicesoutbox.filter(service => service['user_id'] != user_id).map((service, index) => (
                      <li style={{ height: '3rem', padding: '2%', cursor: 'pointer' }} key={index}
                        onClick={() => {
                          saveReplay(service['id'])
                          window.location.href = `./pricing-request?id=${service['id']}`;
                        }}>
                        <div className='outboxNotf'>
                          <Image
                            src={'/images/blueIcon.png'}
                            width={30}
                            height={30}
                          ></Image>
                          <div>
                            <div></div>
                            <div style={{ fontSize: '12px' }}>{service['massege']} ({activeLanguage === 'ar' ? service['serviceName_ar'] : service['serviceName']})</div>
                          </div>
                        </div>
                      </li>
                    ))}
                  </>}</>}


                  {Object.keys(inboxByReqId).map((reqId) => {
                    console.log('wwwwwwwww');
                    console.log(inboxByReqId);
                    console.log(req);
                    
                    const messages = inboxByReqId[reqId];
                    const count = Array.isArray(messages) ? messages.filter((msg: any) => msg.receiver_id === user_id.toString()).length : 0;
                    if (count > 0) {
                      return (
                        <li
                          style={{ height: '3rem', padding: '2%', cursor: 'pointer' }}
                          key={reqId}
                          onClick={() => {
                            // window.location.href = `./pricing-replay?id=${reqId}`;
                            console.log(reqId);
                            
                          }}
                        >
                          <div className='outboxNotf'>
                            <Image src={'/images/yellowIcon.png'} width={30} height={30}></Image>
                            <div>
                              <div></div>
                              <div style={{ fontSize: '12px' }}>
                                {count} {activeLanguage === 'ar' ? inboxByReqId[reqId][0]['sender_id'] : 'Pricing Requests'}
                              </div>
                            </div>
                          </div>
                        </li>
                      );
                    }
                  })}
                </ul>
              </div>
            )}
          </div>
          <div className='user_profile-defult-gray-button'
            onClick={() => {

            }}>
            <Image src={'/images/man.png'}
              width={30}
              height={30}
            ></Image>
          </div>
          <div className='user_header'>
            <div className='user_profile-defult-gray-button' onClick={handleNotificationsClick}>
              <div className='notCon'>{notifications.length > 0 && <div className='notifi'>{notifications.length}</div>}</div>
              <Image src={'/images/offer.png'} width={30} height={30} />
            </div>
            {showNotifications && (
              <div className='notification-dropdown'>
                <ul>
                  {notifications.length > 0 && <>
                    {notifications.map((notification, index) => (
                      <li className='ili' key={index}
                        onClick={() => {
                          readNotification(notification['id'], notification['user_id'])
                        }}>{
                          (activeLanguage == 'ar' ? notification['message_ar'] : notification['message'])}</li>
                    ))}
                  </>}
                </ul>
              </div>
            )}
          </div>
          <div className='user_profile-defult-gray-button'>
            <Image src={'/images/financial-growth-icon-blue.png'}
              width={30}
              height={30}
            ></Image>
          </div>
          <div className='user_profile-defult-gray-button_out' onClick={() => {
            sessionStorage.removeItem('user_email')
            sessionStorage.removeItem('logedin')
            sessionStorage.setItem('priceing', 'false')
            window.location.href = '/'
          }}>
            <Image src={'/images/logout.png'}
              width={20}
              height={20}
            ></Image>
            <p>{t('logout')}</p>
          </div>
        </div>
      </Row>


    </StyledHeader>
  );
}
export default UserHeader;
