package com.gagein.dp.platform.common.api;



/**
 * SN site oAuth keys and tokens. Both APp and DP should share these key definitions. 
 * Do not create separate property files to maintain the keys.
 * 
 * 
Facebook:
	http://www.facebook.com/developers/ 
	snappmanager@gagein.com/market1ng12345

LINKEDIN:
	https://www.linkedin.com/secure/developer
	snappmanager@gagein.com/market1ng12345
	

TWITTER:
	http://dev.twitter.com/apps
	igool/caicai
	TODO: FIX AND UPDATE
	
		
SALESFORCE:
	http:developer.force.com
	jxi@gagein.com/passw0rd0  [email is snappmanager@gagein.com]

YAMMER:
	https://www.yammer.com/client_applications
	snappmanager@gagein.com/market1ng12345
	
 * @author jxi
 *
 */

public class SN {
	
	private static String website;
	
	public static void setWebsite(String website){
		setWebsite(website,false);
	}
	
	public static void setWebsite(String website,boolean override){
		if (override || !isSetWebsite()) {
			SN.website = website;
		}
	}
	
	public static boolean isSetWebsite(){
		return website != null && website.length() > 0;
	}
	
	public static String getWebsite(){
		return SN.website;
	}
	

	public static class FACEBOOK {
		
		/**
		 * App ID
	    136211636426538
	API Key
	    8e2bbd413c44517bc080c58c9cb9637a
	App Secret
	    b33dfea421742b2a626097ef73ccecc9
		 */
		private static SITE_KEYS localKeys = new SITE_KEYS(
				"GageInApp.localhost",
				"http://localhost:8080/",
				"136211636426538",
				"8e2bbd413c44517bc080c58c9cb9637a",
				"b33dfea421742b2a626097ef73ccecc9"
				);

		/*
		 * App ID
	    166231010059122
	API Key
	    de48c6821473fc0b292125ce33e232bc
	App Secret
	    aeb6f7f56e47ab51a2e4b9f6def17ed8
		 */
		private static SITE_KEYS qaKeys = new SITE_KEYS(
				"GageInApp.qa",
				"http://gagein.dyndns.org:3031/",
				"166231010059122",
				"de48c6821473fc0b292125ce33e232bc",
				"aeb6f7f56e47ab51a2e4b9f6def17ed8"
				);
		
		/**
		 * App ID
	    180436025308014
	API Key
	    240883bfe2af9b0ce6a004768dda38ac
	App Secret
	    dd04f371d1c1691e4926164bf3a6ed72
	Site URL
	    http://gageincn.dyndns.org:3031/webapp?a=1
	Site Domain
	    dyndns.org
		 */
		private static SITE_KEYS qacnKeys = new SITE_KEYS(
				"GageInApp.qacn",
				"http://gageincn.dyndns.org:3031/",
				"180436025308014",
				"240883bfe2af9b0ce6a004768dda38ac",
				"dd04f371d1c1691e4926164bf3a6ed72"
				);
		
		/**
		 * App ID
	    158281777525249
	API Key
	    52fa3cbbd89ac579b40348a8a2067dc7
	App Secret
	    f77a62aa556e0f5bd27fc4797044bd91
		 */
		private static SITE_KEYS stagingKeys = new SITE_KEYS(
				"GageInApp.staging",
				"http://gageinstaging.dyndns.org",
				"158281777525249",
				"52fa3cbbd89ac579b40348a8a2067dc7",
				"f77a62aa556e0f5bd27fc4797044bd91"
				);
		
		/**
		 * App ID
	    159696740721866
	API Key
	    68150a5a50b230c6a6ea2d13a646d869
	App Secret
	    b813b378224003ce0981bc7188ff97fd
		 */
		private static SITE_KEYS productionKeys = new SITE_KEYS(
				"GageIn",
				"http://www.gagein.com/",
				"159696740721866",
				"68150a5a50b230c6a6ea2d13a646d869",
				"b813b378224003ce0981bc7188ff97fd"
				);
		
		private static SITE_KEYS demoKeys = new SITE_KEYS(
				"GageInApp.demo",
				"http://gageindemo.dyndns.org/",
				"145327812194205",
				"7cb21f9a4594361ec9497761eb78de5a",
				"ca0893a14a9a33987f945fb460b2918c"
				);
		
		
		/**
		 * get the SITE_KEYS based on website
		 * 
		 * @param website String
		 * @return SITE_KEYS
		 */
		public static SITE_KEYS getKeys() {
			String website = getWebsite();
			if ( productionKeys.isValid(website) ) {
				return productionKeys;
			}
			if ( demoKeys.isValid(website) ) {
				return demoKeys;
			}
			
			if ( stagingKeys.isValid(website) ) {
				return stagingKeys;
			}
			
			if ( qacnKeys.isValid(website) ) {
				return qacnKeys;
			}

			if ( qaKeys.isValid(website) ) {
				return qaKeys;
			}
			
			if ( localKeys.isValid(website) ) {
				return localKeys;
			}
			
			try {
				throw new Exception("FACEBOOK.getKeys(): Unable to get siteKey for " + website );
			} catch (Exception ex ) {
				ex.printStackTrace();
			}
			
			return null;
		}
				
	}
	

	public static class LINKEDIN {
		
		/**
		 * linked In does not care about the website. so just one set of keys
		 * @author jxi
		 *
		 */
		private static SITE_KEYS productionKeys = new SITE_KEYS(
				"GageIn",
				"http://www.gagein.com/",
				"",
				"JG-8S3mdrOdAUT2tuZPadrAYX-Y7tWol-z3fashTf44aDRNLhqkmz6GD0XrKIhfx",
				"4UUmZlEbsoMr3tk9FiDmNFmKOHWsvYgt0o0QrESsS1tVjQRRXKlvZWKnjUox9qnJ"
				);
		
		private static SITE_KEYS localKeys = new SITE_KEYS(
				"GageInApp.localhost",
				"http://localhost:8080",
				"",
				"MdAwAcLzK2jb3ii4xpYxhVvuqgNrnPSzYje74kQudJ96youSwf8aPVNBnEGwUSBB",
				"9A_s8P1ya_sEtxyl0tgz7QZRQsKd8-yQFT--R5oImxxMa3Pg3Y_ZL8IYNBrB3VNQ"
				);
		
		private static SITE_KEYS qacnKeys = new SITE_KEYS(
				"GageInApp.qacn",
				"http://gageincn.dyndns.org:3031",
				"",
				"KrVuznl0-o-oEzgrZCuqMlVVxCIiIXidFYBOXI-fxZLRKMApOCQjL6tHbGBHSGGl",
				"te2NTOMf7zoUCqV6fmqo-Z-ofCelDqJCJhFoNs47lIh6o4Xk_ZLR-ryHOtCjOjCg"
				);
		private static SITE_KEYS qaKeys = new SITE_KEYS(
				"GageInApp.qa",
				"http://gagein.dyndns.org:3031",
				"",
				"FnEm254vBARXptyK7m67WdOhccOW6tof0H2DTB_vtCba4QT5zqle7ZPseUvLNqYZ",
				"vA6GyaCsTHUFdO5TyO1M2iVJrd8FxhWA4Onaopy_1sj6Ekmy3E1FoLVv1c_86T_z"
				);
		
		private static SITE_KEYS stagingKeys = new SITE_KEYS(
				"GageInApp.staging",
				"http://gageinstaging.dyndns.org",
				"",
				"KCFBq5BRcc5HnSfJ4e-9RAZEdbhoNyLLUx51kjRyBfwpJNk2eIDxICYQjNKjxRxV",
				"1N5XkcmzqbOlgxBGXnqTVxH6OUvwnrEXglFbByDY5w4DZav92nNSEy5Ex33zHZUB"
				);
		
		private static SITE_KEYS demoKeys = new SITE_KEYS(
				"GageInApp.demo",
				"http://gageindemo.dyndns.org/",
				"",
				"vkr4AkuIzlhxGSts3EKvPitIg9iOCTM-goRMfmizCT8U2x5wDCAB4MZSwOes1tW1",
				"VYe-sLjl3Zs7vrs09QMUkSiRgK8jHusF0_ZZUVMueEsdlkjKCnZyvmZf6LqfgeYm"
				);
		
		/**
		 * get the SITE_KEYS based on website
		 * 
		 * @param website String
		 * @return SITE_KEYS
		 */
		public static SITE_KEYS getKeys() {
			
			String website = getWebsite();
			if ( productionKeys.isValid(website) ) {
				return productionKeys;
			}
			
			if ( demoKeys.isValid(website) ) {
				return demoKeys;
			}
			
			if ( stagingKeys.isValid(website) ) {
				return stagingKeys;
			}
			
			if ( qacnKeys.isValid(website) ) {
				return qacnKeys;
			}

			if ( qaKeys.isValid(website) ) {
				return qaKeys;
			}
			
			if ( localKeys.isValid(website) ) {
				return localKeys;
			}
			
			try {
				throw new Exception("LINKEDIN.getKeys(): Unable to get siteKey for " + website );
			} catch (Exception ex ) {
				ex.printStackTrace();
			}
			
			return null;
		}		
	}
	

	public static class TWITTER {
		private static SITE_KEYS productionKeys = new SITE_KEYS(
				"GageIn",
				"http://www.gagein.com/",
				"",
				"uFZWraQfaDHFcQbKysJA",
				"qGMycU3ezTVblxZaf7Gc7JENOM8OokEmtKx1yCaAmcI",
				"226796270-Wq8OjzLuXz3JmRRfDKZqTu6TeDRmgy9te26usWs",
				"ij72Vbaa7fTIo0LMl1JZMEUAFaYSRmwOOJmT04Umnc"
				);
		private static SITE_KEYS localKeys = new SITE_KEYS(
				"GageInApp.localhost",
				"http://127.0.0.1:8080",
				"",
				"aL1IjfI8zuv0IyGX9sTlLQ",
				"IH3ipqceMUgC6uilmPl4Qj61zkNu54pvyeL3N3FsM3s",
				"226796270-mP0BsmMjYfzMqQFZbCQzFj6uQDWtUwGhcCixIMfo",
				"8gL8Bh5FXKNVteU30exegWb2Jabepm7cNA3jlpCs"
				);
		
		private static SITE_KEYS qacnKeys = new SITE_KEYS(
				"GageInApp.qacn",
				"http://gageincn.dyndns.org:3031",
				"",
				"jq33SP6aQ85huQTmStWOA",
				"ciSJujyyZGOeeMX7xSqyI8tnNBVc4hKdV1KejZJIiU",
				"226796270-mP0BsmMjYfzMqQFZbCQzFj6uQDWtUwGhcCixIMfo",
				"8gL8Bh5FXKNVteU30exegWb2Jabepm7cNA3jlpCs"
				);
		private static SITE_KEYS qaKeys = new SITE_KEYS(
				"GageInApp.qa",
				"http://gagein.dyndns.org:3031",
				"",
				"6oN8xtQ7zMICzeqUdBrqGg",
				"t6xoPajeYk79Sgl3HTY0dwVaLdqfLa1Dr0UyqiWWCw"
				);
		
		private static SITE_KEYS stagingKeys = new SITE_KEYS(
				"GageIn.staging",
				"http://gageinstaging.dyndns.org/",
				"",
				"eFyXq7uhH1Lj6LPZ1fFqA",
				"UHgBLk7m0g8Wh0CU2ytAfRihMosx1j9lnXvL9qdsQA",
				"226796270-W7ykpXlBId0YZN46yWF255eiqo2vsWgGpl9hDRNo",
				"MuNF6SBZBsg3j1CZ3QaTDCsCfd1QLK34fnUD35WVj0"
				);
		
		private static SITE_KEYS demoKeys = new SITE_KEYS(
				"GageIn.demo",
				"http://gageindemo.dyndns.org/",
				"",
				"wiibcHpMLjoKcxUCk1ou7A",
				"6C66cbObQRccG92ltqU1Eikkn2yfSASB7Wx3CsBUk",
				"300444263-M2T8z6vrEPWU3XXHBQ7GvpufqOe5sYHGcyVP6OY1",
				"uUaRgdYkXPcxexVNpU1GgWdTBJR9HBos2IeSzgx2qfg"
				);
		
		/**
		 * get the SITE_KEYS based on website
		 * 
		 * @param website String
		 * @return SITE_KEYS
		 */
		public static SITE_KEYS getKeys() {

			String website = getWebsite();
			if ( productionKeys.isValid(website) ) {
				return productionKeys;
			}
			
			if ( demoKeys.isValid(website) ) {
				return demoKeys;
			}
			
			if ( stagingKeys.isValid(website) ) {
				return stagingKeys;
			}
			
			if ( qacnKeys.isValid(website) ) {
				return qacnKeys;
			}

			if ( qaKeys.isValid(website) ) {
				return qaKeys;
			}
			
			if ( localKeys.isValid(website) || website.indexOf("127.0.0.1:") > 0 || website.indexOf("localhost:") > 0) {
				return localKeys;
			}

			try {
				throw new Exception("TWITTER.getKeys(): Unable to get siteKey for " + website );
			} catch (Exception ex ) {
				ex.printStackTrace();
			}
			
			return null;
		}
	}
	

	public static class SALESFORCE {
		private static SITE_KEYS productionKeys = new SITE_KEYS(
				"GageIn",
				"http://www.gagein.com/",
				"",
				"3MVG9QDx8IX8nP5Rg7yD2yhM0mSIoG5JhtwAfaXVxWdWvLQ2c9dbC5IdPIt8bV9wAgE4sLNdWDWrvrHs7izVe",
				"2673905608344491606"
				);
		
		private static SITE_KEYS localKeys = new SITE_KEYS(
				"GageIn.localhost",
				"http://localhost:8080",
				"",
				"3MVG9QDx8IX8nP5Rg7yD2yhM0mZ1B5qRXXaIqmF3KCA.ycm5l7WI5cOzwLzyadnkqgfAzChHWRF6mvgDN4KCF",
				"961117055568386841"
				);

		private static SITE_KEYS qacnKeys = new SITE_KEYS(
				"GageInApp.qacn",
				"http://gageincn.dyndns.org:3031",
				"",
				"3MVG9QDx8IX8nP5Rg7yD2yhM0mTep67cL1i5rgZf680Zc30kzy9j6G_vyEvH9EZaUcsp3uMGMK_58ELiarVjc",
				"1169752873003592920"
				);

		
		private static SITE_KEYS stagingKeys = new SITE_KEYS(
				"GageInApp.staging",
				"http://gageinstaging.dyndns.org",
				"",
				"3MVG9QDx8IX8nP5Rg7yD2yhM0mXzbRfDUkFTsEmylcNYdpLf3MpiegNCjNhLn4WoQ36aNg5a5muZtOtiBsGcs",
				"5228913310560653116"
				);
		
		private static SITE_KEYS demoKeys = new SITE_KEYS(
				"GageInApp.demo",
				"http://gageindemo.dyndns.org/",
				"",
				"3MVG9QDx8IX8nP5Rg7yD2yhM0mRvh1db.tHJhAvmBc4Tsze3dupGHqlChVxEiCFPLLV8qYtL.oX8Um8sZvg4p",
				"351992569387772761"
				);
		
		/**
		 * get the SITE_KEYS based on website
		 * 
		 * @param website String
		 * @return SITE_KEYS
		 */
		public static SITE_KEYS getKeys() {
			
			String website = getWebsite();
			
			if ( productionKeys.isValid(website) ) {
				return productionKeys;
			}
			
			if ( demoKeys.isValid(website) ) {
				return demoKeys;
			}
			
			if ( stagingKeys.isValid(website) ) {
				return stagingKeys;
			}
			
			if ( qacnKeys.isValid(website) ) {
				return qacnKeys;
			}

			if ( localKeys.isValid(website) ) {
				return localKeys;
			}
			
			try {
				throw new Exception("SALESFORCE.getKeys(): Unable to get siteKey for " + website );
			} catch (Exception ex ) {
				ex.printStackTrace();
			}

			return null;
		}	
	}
	

	public static class YAMMER {
		private static SITE_KEYS productionKeys = new SITE_KEYS(
				"GageIn",
				"http://www.gagein.com/",
				"",
				"f9KlrzC1wkYJdmsefBPZrw",
				"WKEf4j9D9w2v67GJTkd3sluOSxVdzVvo5RljJ8ad5U"
				);
		
		private static SITE_KEYS localKeys = new SITE_KEYS(
				"GageInTest.local",
				"http://localhost:8080",
				"",
				"6LYUTdNHNfvUW8zLBhq6w",
				"n5AORchjCc1hXlrZ1iiGuiZ9uFuivZAkfh09p0Eag"
				);

		private static SITE_KEYS qacnKeys = new SITE_KEYS(
				"GageinTest_QA",
				"http://gageincn.dyndns.org:3031",
				"",
				"chxwyjPv91RpvU9NYAMQw",
				"Ersaq04Gxeu6dqSyb1vUWuU8XWm1XjG0VMpJ6NVpkpw"
				);

		
		private static SITE_KEYS stagingKeys = new SITE_KEYS(
				"GageInApp.staging",
				"http://gageinstaging.dyndns.org/",
				"",
				"GZ2f0vLVWU5W1LKsvg",
				"10m9zStHZB1O3arzD1LmidNIpRz4tji8oowadfi5bU"
				);
		
		private static SITE_KEYS demoKeys = new SITE_KEYS(
				"GageInApp.demo",
				"http://gageindemo.dyndns.org/",
				"",
				"FXyP6k5niRtztEEBA88FWg",
				"TTnjd7NJpHCubsM5NVgmmiRFBEzxQXntOW2nv8in8"
				);
		
		/**
		 * get the SITE_KEYS based on website
		 * 
		 * @param website String
		 * @return SITE_KEYS
		 */
		public static SITE_KEYS getKeys() {
			
			String website = getWebsite();
			
			
			if ( productionKeys.isValid(website) ) {
				return productionKeys;
			}
			
			if ( demoKeys.isValid(website) ) {
				return demoKeys;
			}
			
			if ( stagingKeys.isValid(website) ) {
				return stagingKeys;
			}
			
			if ( qacnKeys.isValid(website) ) {
				return qacnKeys;
			}
	
			if ( localKeys.isValid(website) ) {
				return localKeys;
			}
			
			try {
				throw new Exception("YAMMER.getKeys(): Unable to get siteKey for " + website );
			} catch (Exception ex ) {
				ex.printStackTrace();
			}
	
			return null;
		}		
	}
	
}
