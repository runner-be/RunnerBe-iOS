//
//  PolicyType.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/03/02.
//

import Foundation

enum PolicyType {
    case service
    case privacy_collect
    case privacy_deal
    case location
}

extension PolicyType {
    var title: String {
        switch self {
        case .service:
            return "서비스 이용약관"
        case .privacy_collect:
            return "개인정보의 수집 및 이용 동의"
        case .privacy_deal:
            return "개인정보처리방침"
        case .location:
            return "위치기반서비스 이용약관"
        }
    }

    var fName: String {
        switch self {
        case .service:
            return "Policy_Service"
        case .privacy_collect:
            return "Policy_Privacy_Collect"
        case .privacy_deal:
            return "Policy_Privacy_Deal"
        case .location:
            return "Policy_Location"
        }
    }
}

extension PolicyType {
    var contents: String {
        switch self {
        case .service:
            return """
            제 1조(목적)

            이 약관은 ‘애플맹고’(이하 “회사”)가 제공하는 ‘러너비’(이하 “서비스”)과 관련하여, 회사와 이용고객 간에 서비스 이용조건 및 절차, 회사와 회원 간의 권리, 의무 및 기타 필요 사항을 규정함을 목적으로 합니다. 또한 본 약관은 유무선 PC통신, 스마트폰(아이폰, 안드로이드폰 등) 어플리케이션 및 모바일 웹 등을 이용하는 전자상거래 등에 대해서도 그 성질에 반하지 않는 한 준용됩니다.

            제 2조(용어의 정의)

            1. "서비스"라 함은 구현되는 단말기(PC, TV, 휴대형단말기 등의 각종 유무선 장치를 포함)와 상관없이 회원이 이용할 수 있는 러너비 서비스 및 회사가 추가 개발하거나 다른 회사와 제휴계약 등을 통해 제공되는 일체의 서비스를 의미합니다.

            2. "회원"이라 함은 회사의 서비스에 접속하여 이 약관에 따라 회사와 이용계약을 체결하고 회사가 제공하는 서비스를 이용하는 고객을 의미합니다.

            3. "아이디"라 함은 회원의 식별과 서비스 이용을 위하여 회원이 정하고 회사가 승인하는 문자 또는 문자와 숫자의 조합을 의미합니다.

            4. "운동 모임"이라 함은 회사의 서비스를 통해 회원이 직접 만든 단발성/정기성 모임으로 두 명 이상의 회원들과 모여 운동을 즐길 수 있도록 회사가 제공하는 서비스를 의미합니다.

            5. “채팅방” 이라 함은 방장 포함 “운동 모임”의 인원이 2명 이상 참가 신청이 완료되었을 때 생성되는 채팅방을 의미합니다.

            6. “쪽지방”이라 함은 참가 멤버가 방장에게 참가 신청을 전송할 때 생성되는 쪽지방을 의미합니다.

            7. “방장”이라 함은 회사가 제공하는 서비스를 통해 “운동모임”를 개설할 수 있는 권한을 가진 회원을 말합니다.

            8. "참가 멤버"라 함은 운동모임에 참가신청이 되어 있는, 운동모임의 구성원으로, 러너비에 소속된 회원을 의미합니다.

            9. "게시물"이라 함은 회원이 서비스를 이용함에 있어 서비스에 게시한 모든 부호ㆍ문자ㆍ음성ㆍ음향ㆍ화상ㆍ동영상 등의 정보 형태의 글, 사진, 동영상, 채팅메시지 및 각종 파일과 링크 등을 의미합니다.

            10. “포인트”라 함은 이용자가 유상으로 결제하여 충전하거나, 회사로부터 적립 받아 앱에서 상품 구매, 서비스 이용 등에 사용할 수 있는 전자적 지급수단을 말합니다. 이 약관에서 정의되지 않은 용어는 관련법령이 정하는 바에 따르며, 그 외에는 일반적인 상거래 관행에 의합니다.

            11. "약정"이라 함은, 구매, 판매, 공급, 지급, 제작, 중개, 중계, 당첨 등 서비스 내부에서 회사와 회원 사이에 발생한 계약, 서약, 약속 등을 말합니다.

            제3조 (약관의 명시, 효력과 개정)

            1. 회사는 이 약관의 내용을 회사의 상호, 영업소 소재지, 대표자의 성명, 사업자등록번호, 연락처 등과 함께 회원이 확인할 수 있도록 사이트/앱 초기 서비스 화면(전면)에 게시합니다. 다만, 이 약관의 구체적 내용은 연결화면을 통하여 볼 수 있습니다.

            2. 회사는 약관의 규제에 관한 법률, 전자문서 및 전자거래기본법, 전자서명법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 전자상거래 등에서의 소비자보호에 관한 법률, 전자금융거래법, 위치정보의 보호 및 이용 등에 관한 법률 등 관련법을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.

            3. 회사가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행 약관과 함께 사이트/앱 초기화면에 최소 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 회원의 권리, 의무에 중대한 영향을 주는 변경이 이루어질 경우에는 적용일자 30일 이전부터 공지합니다.

            4. 제3항에 따라 공지된 적용일자 이후에 회원이 회사의 서비스를 계속 이용하는 경우에는 개정된 약관에 동의하는 것으로 간주합니다. 개정된 약관에 동의하지 아니하는 회원은 언제든지 자유롭게 서비스 이용계약을 해지할 수 있습니다.

            5. 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 관련법령 또는 상관례에 따릅니다.

            제4조 (이용계약의 성립)

            1. 이용계약은 회원의 약관 동의, 이용신청, 회사의 승낙에 의하여 성립합니다.

            2. 회사의 서비스 이용을 위해 이용자가 제1항과 같이 동의한 후, 서비스 이용을 위하여 절차에 따른 필수사항을 입력하고, "확인" 을 누르는 방법으로 합니다. 다만, 회사가 필요하다고 인정하는 경우 회원에게 별도의 자료를 제출하도록 할 수 있습니다.

            제5조 (이용신청 및 승낙)

            1. 회원은 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 가입 의사를 표시함으로써 이용계약을 신청합니다.

            2. 회사는 다음 각 호에 해당하는 이용신청에 대하여는 이를 승낙하지 아니하거나 사후에 이용계약을 해지할 수 있습니다.

            (1) 이미 가입된 회원과 이메일 주소가 동일한 경우

            (2) 타인의 명의 내지 개인정보를 도용하거나, 등록 내용에 허위, 기재누락, 오기가 있는 경우

            (3) 회사에 의하여 이용계약이 해지된 날로부터 3개월 이내에 재이용을 신청하는 경우

            (4) 이 약관에 의하여 이전에 회원자격을 상실한 적이 있는 경우(회원자격 상실 후 3개월이 경과한 자로서 회사의 회원 재이용 승낙을 얻은 경우에는 예외)

            (5) 부정한 용도 또는 영리를 추구할 목적으로 본 서비스를 이용하고자 하는 경우

            (6) 이 약관 또는 관련 법령을 위반한 경우

            (7) 이전에 동일∙유사한 아이디 또는 다른 아이디를 통하여 부정한 사용을 한 이력이 있거나 의심되는 경우

            (8) 관련법령에 위배되거나 사회의 안녕질서 혹은 미풍양속을 저해할 수 있는 목적으로 신청한 경우

            (9) 회사의 서비스 운영에 따른 설비에 여유가 없거나, 기술 상 지장이 발생하였거나 발생할 가능성이 있는 경우

            (10) 회원이 회사나 다른 회원, 기타 타인의 권리나 명예, 신용, 기타 정당한 이익을 침해하는 행위를 한 경우

            (11) 회사가 제공하는 각 약관 내지 관련 법령에 위배되거나 위배될 가능성이 있는 부당한 이용신청임이 확인된 경우

            (14) 기타 회원과의 계속적 거래관계를 지속하기 어렵다고 합리적으로 판단되는 경우

            3. 전항 제5호에 따라 부정한 용도 또는 영리를 추구할 목적으로 본 서비스를 이용하였거나, 제7호에 따라 부정한 사용을 한 이력이 있는 경우 해당 위반사유가 발생한 시점에 제7조 제1항에 따른 해지의 의사표시가 있었던 것으로 보아 계약이 자동종료 됩니다.

            제6조 (회원정보의 수정)

            회원은 이용신청 시 작성한 이용신청 사항에 변경이 있는 경우, 온라인으로 개인정보를 수정하거나 이메일, 전화, 팩스 등의 방법으로 회사에 그 변경사항을 알려야 합니다. 이를 알리지 않아 발생하는 불이익에 대한 모든 책임은 회원에게 있으며, 회사는 이에 대한 책임을 지지 않습니다.

            제7조 (이용계약의 종료)

            1. 회원의 해지

            (1) 회원은 언제든지 회사에게 해지의사를 통지함으로써 이용계약을 해지할 수 있습니다.

            (2) 이용계약은 회사가 회원의 해지의사를 받아 해지 처리하는 시점에 종료됩니다.

            (3) 본 항에 따라 해지를 한 회원은 이 약관이 정하는 회원가입절차와 관련조항에 위반되지 않는 경우 회원으로 다시 가입할 수 있습니다.

            2. 회사의 해지

            (1) 회사는 회원에게 제5조 2항에서 정하고 있는 이용계약의 해지사유가 있는 경우 회원과의 이용계약을 해지할 수 있습니다.

            (2) 회사는 해당 회원에게 14일 이내의 기간을 정하여 사전에 해지사유에 대한 의견진술의 기회를 부여할 수 있습니다.

            제8조 (이용제한 등)

            1. 회사는 회원이 다음 각 호의 사유에 해당하는 경우 경고 조치를 통해 시정을 요구하고, 지체 없이 하자가 치유되지 않는 경우 회원에 대한 위반사항 게시, 일시정지 또는 영구이용정지 등으로 서비스의 이용을 단계적으로 제한할 수 있습니다. 다만, 아래 제3호 내지 제10호의 경우에는 회복할 수 없는 손해를 방지하기 위하여 회원에 대한 별도 경고 없이 즉시 일시정지 조치를 할 수 있으며, 중대한 범죄와 관련된다고 판단되는 경우 민형사상 조치와 함께 회원자격의 영구이용정지 조치를 통해 서비스 이용을 제한할 수 있습니다.

            (1) 가입 신청 시 허위 내용을 등록한 경우

            (2) 타인의 서비스 이용을 방해하거나 정보를 도용하는 등 전자상거래 질서를 위협하는 경우

            (3) 회사를 이용하여 법령과 이 약관이 금지하거나 공공질서, 미풍양속에 반하는 행위를 하는 경우

            (4) 회원이 회사 시스템이나 서비스를 경유하지 않고 직접 모임을 모집할 목적으로 회원 간에 개인정보, 연락처 등(전화번호, 이메일, 메신저, SNS ID 등을 포함하되 이에 한정되지 아니함)를 교환하거나, 방장의 운동 콘텐츠 등 소개페이지, 게시판, 후기, 이미지/영상, 리뷰, 문의란 등에 위 개인정보, 연락처 등을 기재하거나 기재하도록 유도하는 경우

            (5) 방장에게 운동모임 등과 관련 없거나 불쾌한 언어사용, 비정상적인 행위 등을 한 것에 대하여 신고가 접수된 경우

            (6) 고객센터 문의 및 전화 상담 내용이 욕설, 폭언, 성희롱, 반복 민원을 통한 업무방해 등에 해당하는 경우

            2. 회사는 전항에도 불구하고 저작권법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 여신전문금융업법 등 기타 현행법령을 위반한 명의도용 및 결제정보 도용, 불법 통신 및 해킹, 악성프로그램의 배포, 접속권한 초과, 신용카드 부정거래 등의 경우에 즉시 영구이용정지를 할 수 있습니다.

            3. 회원은 본조에 따른 이용제한의 경우 고객센터를 통하여 소명자료를 구비하여 이의를 제기할 수 있습니다. 회사가 회원의 이의제기 및 소명이 충분하다고 판단하는 경우 서비스 이용을 즉시 재개할 수 있습니다.

            4. 본조에 따른 영구이용정지 시 제15조의 4 제1항에 의하여 적립된 포인트 및 기타 혜택 등도 모두 소멸되며, 회사는 이에 대해 별도로 보상하지 않습니다.

            5. 회사는 1년 이상 서비스를 이용하지 않는 회원의 개인정보를 별도로 분리 보관하여 관리하며, 구체적인 파기 등 절차에 대하여는 개인정보 보호법 등 해당 시점에 유효하게 적용되는 법령의 절차에 따릅니다.

            제9조 (회원의 이메일 및 비밀번호에 대한 의무)

            1. 회원은 자신의 이메일과 비밀번호에 관한 관리책임이 있으며 이를 소홀히 하여 발생한 모든 민,형사상의 책임은 회사의 고의 또는 중과실이 없는 한 회원 자신에게 있습니다. 회원은 자신의 이메일 및 비밀번호를 제3자에게 알려주어서는 안되며, 회원이 이메일과 비밀번호를 제3자에게 알려줌으로써 발생한 손해에 대해서 회사는 책임을 지지 않습니다. 이메일과 비밀번호가 회원의 의사에 반하여 유출되거나 기타의 사정으로 제3자가 사용하고 있음을 인지한 경우 즉시 비밀번호를 변경하여야 하고, 회사에 통보한 다음 회사의 안내를 따라야 합니다. 이를 소홀히 하여 발생한 모든 책임은 회원이 집니다.

            2. 회원은 자신의 이메일 및 비밀번호를 제3자에게 이용하게 해서는 안됩니다.

            3. 회원이 자신의 이메일 및 비밀번호를 도난 당하거나 제3자가 이용하고 있음을 인지한 경우에는 즉시 회사에 통보하고, 회사의 조치가 있는 경우에는 그에 따라야 합니다.

            4. 회원이 제3항에 따른 통지를 하지 않거나 회사의 조치에 응하지 아니하여 발생하는 모든 불이익에 대한 책임은 회원에게 있습니다.

            제 10 조 (회원의 의무)

            1. 회원은 관계법령, 이 약관의 규정, 이용안내 등 회사가 통지하는 사항을 준수하여야 하며, 기타 타인의 권익을 침해하거나, 회사 업무에 방해되는 행위를 하여서는 안됩니다.

            2. 회원은 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안됩니다.

            (1) 타인의 정보 도용 및 사칭

            (2) 허위내용의 등록 및 회사가 게시한 정보의 허가 받지 않은 변경

            (3) 회원 간의 금전 거래 또는 사기, 기만 등 현행법에 위배되는 행위

            (4) 회사의 서비스에 게시된 정보 또는 회원이 서비스를 이용하여 얻은 정보를 회사의 사전 승낙 없이 영리 또는 비영리의 목적으로 복제, 출판, 방송 등에 사용하거나 제3자에게 제공하는 행위

            (5) 회사의 사전 허락없이 영리의 목적으로 서비스를 이용하는 행위

            (6) 외설, 음란, 폭력 등 기타 현행법 및 미풍양속에 반하는 행동 혹은 내용을 서비스에 게시하는 행위

            (7) 불건전 교제 조장 혹은 매개하기 위한 목적으로 이용하는 행위

            (8) 회사 및 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위

            (9) 회사 및 제3자의 저작권 등 지적재산권에 대한 침해하는 행위

            (10) 본인이 아닌 제3자에게 접속권한을 부여하는 등, 계정보안에 위험을 초래하는 행위

            (11) 다른 회원의 이메일 또는 소셜 로그인 계정을 도용하여 서비스를 이용하는 행위

            (12) 서비스를 이용할 권리를 양도하고 이를 대가로 금전을 수수하는 행위

            (13) 홍보를 목적으로 모임 개설을 반복하며 서비스 운영에 지장을 주는 행위

            (14) 청소년보호법에서 규정하는 청소년유해매체물을 게시(링크 포함)하는 행위

            (15) 외설 또는 폭력적인 메시지, 동영상, 음성 기타 공공질서, 미풍양속에 반하는 정보, 문장, 도형, 동영상, 음성 등 앱에 공개, 게시 또는 다른 이용자에게 유포하는 행위

            (16) 회사의 직원이나 서비스의 관리자로 가장, 사칭하거나 타인의 명의를 도용하여 글을 게시하거나 메일을 발송하는 행위

            (17) 스토킹, 욕설, 채팅글 도배 등 다른 회원의 서비스 이용을 방해하는 행위

            (18) 다른 회원의 개인정보를 그 동의 없이 수집, 저장, 공개, 유포하는 행위

            (19) 리버스엔지니어링, 디컴파일, 디스어셈블 및 기타 일체의 가공행위를 통하여 서비스를 복제, 분해 또는 모방 기타 변형하는 행위

            (20) 자동 접속 프로그램 등을 사용하는 등 비정상적인 방법으로 서비스를 이용하여 회사의 서버에 부하를 일으켜 회사의 정상적인 서비스를 방해하는 행위

            (21) 기타 본 항에 준하는 경우나 회사가 판단하기에 운영정책에 위배되거나 서비스에 위협이 되는 행위

            3. 회원은 관계법, 이 약관의 규정, 이용안내 및 서비스와 관련하여 공지한 주의사항, 운영정책을 준수하여야 하며 이를 위반한 회원의 경우 회사는 임의로 회원과의 이용계약을 해지하거나 서비스 이용을 제한할 수 있습니다.

            4. 회원은 본 약관을 위배한 회원이나 모임을 회사 측에 신고할 수 있으며 민형사상급의 처벌 문제를 제외한 본 약관 위배에 대한 서비스 이용 제한 여부와 방법은 회사가 판단합니다.

            5. 회사는 신고 내용에 대한 증거자료를 회원에게 요청할 수 있으며 만약 허위 신고로 판명될 경우, 신고한 회원은 서비스 이용에 제한이 있을 수 있습니다.

            6. 회원간의 투명하고 원활한 상호교류를 위하여 참여한 운동모임 활동 횟수가 공개될 수 있습니다.

            7. 회원은 운동모임에 참여한 순간부터 멤버로 활동이 가능하며 리더가 자체적으로 정한 운동모임 운영 방침에 대한 판단과 책임은 참여한 멤버 당사자들에게 있습니다.

            제 11조 회사의 의무

            1. 회사는 관련 법령을 준수하고, 이 약관이 정하는 권리의 행사와 의무의 이행을 신의에 따라 성실하게 합니다.

            2. 회사는 회원이 안전하게 서비스를 이용할 수 있도록 개인정보(신용정보 포함)보호를 위해 보안시스템을 갖추어야 하며 개인정보처리방침을 공시하고 준수합니다.

            3. 회사는 이용자의 수, 이용시간 등을 감안하여 회원이 원활하게 콘텐츠를 이용할 수 있도록 서버다운, 기술적 오류 등에 대비한 설비를 구축하고 필요한 조치를 취합니다.

            4. 회사는 회원의 불만 또는 피해구제요청을 적절하게 처리할 수 있도록 필요한 인력 및 체계(시스템 등)를 구비합니다.

            5. 회사는 동일 또는 유사한 피해가 계속하여 발생하고 있는 사실을 인식한 경우 추가적인 피해를 예방하기 위하여 초기화면이나 공지사항 등에서 그 피해발생 사실과 피해예방을 위한 회원의 조치사항에 대하여 공지합니다.

            제12조 (게시물 및 모임의 관리)

            1. 회원이 관련법 및 각 약관에 위배 되는 내용의 모임을 개설하거나 게시물을 게시할 경우, 회사는 해당서비스, 커뮤니티 또는 게시물을 임의로 삭제, 중단, 변경등의 조치를 할 수 있고 회원의 자격 및 권한을 제한, 정지 및 박탈 할 수 있습니다.

            2. 회원의 게시물로 인한 법률상 이익침해를 근거로, 다른 회원 또는 제3자가 회원 또는 회사를 대상으로 하여 민형사상의 법적조치를 취하거나 관련된 게시물의 삭제를 요청하는 경우, 회사는 관련 게시물에 대한 접근을 잠정적으로 제한 할 수 있습니다.

            제13조 (러너비 운동모임 이용규칙)

            1. 러너비는 회원이 직접 만들어가는 공간입니다.

            (1) 러너비는 회원 분들의 자정능력을 존중합니다. 깨끗하고 신뢰도 있는 모임을 위해 노력해 주시기 바랍니다.

            (2)회원은 서로 예의를 지키고, 존중해야 합니다.

            2. 다음 목록에 해당 하는 게시물의 게시, 모임의 개설을 금지하고 있습니다.

            (1) 욕설, 비아냥, 비속어 등 예의범절에 벗어난 게시물

            (2) 혐오스럽거나 타 회원을 놀라게 하는 게시물

            (3) 성적비하를 포함하는 게시물

            (4) 불건전한 만남, 대화, 통화 등을 목적으로 하는 게시물

            (5) 특정인이나 단체/지역 등을 비방하는 게시물

            (6) 중복글, 도배글, 낚시글, 내용 없는 게시물

            (7) 익명을 악용한 여론조작

            (8) 관련법에 위배되거나, 타인의 권리를 침해 하는 게시물(초상권, 저작권 등)

            (9) 허가되지 않은 광고/홍보물 또는 상업적 게시물(타서비스 및 사이트, 공동구매, 홍보성 이벤트 등)

            (10) 논란 및 분란을 일으킬 수 있는 게시물

            (11) 청소년 유해매체물, 외설, 음란물, 음담패설, 신체사진

            (12) 관리자를 사칭하는 게시물

            (13) 기타 부적합한 게시물

            3. 모임 중 사고 관련 책임

            (1) 러너비는 참여자의 부상을 막기 위해 노력을 하고 있습니다. 운동모임 신청 시 부상에 대한 책임은 참여자 개인에게 있음을 안내해드립니다.

            (2) 서비스 특성상 불특정 다수가 참가하기 때문에 보험 상품을 적용하는데 어려움이 있습니다. 최대한 빠른 시일 내에 보험 연계가 가능하도록 노력하겠습니다.

            4. 다음 목록에 해당하는 규칙을 모두 지켜야 합니다.

            (1) 채팅방의 게시물, 쪽지방 정보, 타 회원 정보, 게시글 목록 정보 등 개인정보에 관련된 일체를 복사, 스크린샷 등을 통해 절대 외부로 유출해서는 안됩니다.

            (2) 타인의 개인 정보 및 계정을 수집, 저장, 공개, 이용하거나, 자신의 개인 정보 및 계정을 공개, 공유해서는 안됩니다.

            (3) 회원이 관련법 및 각 약관에 위배되는 내용의 게시판을 개설하거나 게시물을 게시할 경우, 삭제, 중단, 변경 등의 제재가 가해질 수 있으며, 회원은 자격 및 권한을 제한, 정지, 박탈당할 수 있습니다.

            5. 게시물 신고 제도

            (1) 모임 이용규칙에 어긋난다고 생각하는 게시물은 게시물 상세 페이지 상단 [신고하기] 기능을 이용하여 신고해 주시기 바랍니다.

            (2) 모든 신고는 접수된 순서대로 처리됩니다. 회원의 요청에 따라 게시물을 삭제하지 않습니다.

            (3) 신고가 누적된 회원은 접근 제한 등의 제재가 가해질 수 있습니다.

            (4) 신고 제도를 악용할 경우, 해당 신고는 처리되지 않습니다. 신고 제도를 악용한 회원은 제재가 가해질 수 있습니다.

            6. 허위 사실유포 및 명예 훼손 게시물에 대한 게시 중단요청

            (1) 허위사실 유포 및 명예 훼손 등 권리를 침해하는 게시물의 게시중단을 원하실 경우, 고객센터로 연락을 하셔서 게시 중단 요청을 전달주시기 바랍니다. 연락은 러너비 공식 인스타그램 혹은 0728kes@naver.com으로 가능합니다.

            (2) 게시 중단 요청 시 사실을 증명할 수 있는 자료(스크린샷 등)를 같이 보내 주셔야 합니다.

            (3) 게시 중단 요청은 담당자를 통해 접수된 순서에 따라 처리됩니다.

            (4 )허위사실 유포 및 명예훼손에 해당하지 않는다고 판단되는 경우, 해당 게시물은 게시중단 처리되지 않습니다.

            7. 채팅

            (1) 채팅은 개인간의 사적인 대화 이므로 반말, 비하 등에 대한 제재는 가해지지 않습니다.

            (2) 광고, 스팸, 사기 등 메세지를 받으셨을 경우, 깨끗한 커뮤니티를 위해 신고해 주시기 바랍니다.

            (3) 스팸 신고 시 신고 내용 확인을 위해 채팅내용의 일부가 전송되어 검토됩니다. 스팸 신고로 전송된 메세지를 제외 하고는 누구도 메세지를 열람할 수 없습니다.

            (4) 다수의 회원에게 피해를 끼치는 메세지를 반복적으로 발송할 경우 영구적으로 이용에 제재가 가해질 수 있습니다.

            8. 모임의 취소/ 포인트 반환

            (1) 한 번 개설/참여한 모임의 취소는 참가 인원이 2명 이상인 불가능 하오니, 신중한 개설/참여를 부탁드립니다.

            (2) 인원 미달로 인한 모임 취소 시 포인트는 자동적으로 반환 됩니다.

            (3) 천재지변으로 인해 당일 서비스 이용이 불가능 할 경우 포인트 반환

            -호우주의보 : 3시간 강우량이 60mm 이상 예상되거나, 12시간 강우량이 110mm 이상이 예상될 때

            -강풍주의보 : 육상에서 풍속 14m/s 이상 또는 순간풍속 20m/s 이상이 예상될 때

            -대설주의보 : 24시간 신적설이 5cm이상 예상될 때

            -한파주의보 : 아침 최저기온이 -12°C 이하가 2일 이상 지속 될 것이 예상될 때 (10월~4월 사이)

            -황사주의보 : 400㎍/㎥ 이상일 때

            -폭염주의보 : 일 최고기온이 33°C 이상인 상태가 2일 이상 지속될 것으로 예상될 때

            -기상예보는 기상청 날씨누리 예보를 기준으로 합니다. (용산구 한강로동 기준)

            제14조 (서비스 제공의 중지)

            1. 회사는 다음 각 호에 해당하는 경우 서비스 제공을 중지할 수 있습니다.

            (1) 서비스용 하드웨어, 소프트웨어 등의 보수, 정기 및 비상 점검의 경우

            (2) 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우

            (3) 기타 불가항력적 사유가 있는 경우

            2. 회사는 국가비상사태, 정전, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 때에는 서비스의 전부 또는 일부를 제한하거나 정지할 수 있습니다.

            제15조 (사용 가능한 결제 수단)

            회원은 회사가 운영하는 앱에서 이루어지는 서비스에 대한 대금 지급방법을 다음 각 호의 하나로 할 수 있습니다.

            1. 포인트

            제15조의2 (포인트의 정의 및 종류 등)

            1. 회원은 회사가 정하는 방법에 의하여 유상 결제 또는 기타 방법으로써 아래 각 호에 해당하는 포인트(이하 총칭하여 “포인트”)를 충전 또는 보유할 수 있고, 아래 각 포인트를 회사의 앱 내에서 상품 구매, 서비스 이용 시 대금 지급 수단으로 사용할 수 있습니다.

            (1) 적립 포인트: 이벤트 또는 회사의 서비스 정책, 마케팅 및 프로모션 등을 통하여 회원에게 무상으로 지급되는 포인트

            (2) 충전 포인트: 회원이 유상으로 구매한 포인트

            (3) 반환 포인트: 구매한 상품/서비스의 취소/환불/유효기간 만료 등의 적법한 사유가 발생하여 회원이 반환 받은 포인트

            2. 전항에 따라 회원이 서비스를 포인트로 결제하는 경우, 유효기간 종료일이 먼저 도래하는 순서로 사용됩니다

            3. 회원은 유효기간 내의 충전 포인트의 미사용 잔액에 대하여는 회사가 정하는 방법 및 절차에 의하여 언제든지 환급을 요구할 수 있습니다.

            4. 회원은 본조에 따른 포인트를 다른 회원 또는 제3자에게 양도 또는 대여할 수 없으며, 기타 여하한의 방법으로 유상 또는 무상으로 거래할 수 없습니다.

            5. 회사는 회원이 회사가 승인하지 않은 방법으로 포인트를 획득하거나 부정한 목적이나 용도로 포인트를 사용하는 경우, 그 규모나 경중에 따라 해당 회원의 포인트의 사용을 제한하거나, 포인트를 사용한 구매신청을 취소하거나, 제8조에 따른 제반 조치를 할 수 있습니다.

            제15조의3 (포인트 적립조건 등)

            1. 회사는 포인트의 적립기준, 적립제한, 사용방법, 사용기준 및 사용제한에 관한 사항(이하 “포인트 적립조건”이라 합니다)을 정하여 서비스 화면에 게시하거나 회원에게 통지합니다. 다만 관련 법령의 개폐, 영업환경의 변화, 경영상 필요성, 기타 회사의 정책에 따라 적립조건은 변경될 수 있습니다.

            2. 회원이 적립 포인트로 지급한 결제를 취소하는 경우 결제 취소 시점에 이미 해당 적립 포인트의 유효기간이 만료되지 않는 부분에 한하여 적립 포인트를 환급합니다.

            3. 적립 포인트는 현금으로 환급 또는 전환될 수 없습니다.

            4. 상품구매, 서비스 이용, 결제 등이 취소되는 경우 이에 수반하여 적립된 적립 포인트는 함께 취소되어 효력을 상실합니다.

            5. 회원 탈퇴 시 미사용한 적립 포인트는 즉시 소멸되며, 탈퇴 후 재가입하더라도 복구되지 아니합니다.

            제16조 (포인트 결제 및 환불규정)

            1. 포인트를 충전할 수 있는 결제 수단은 아래와 같습니다.

            - 체크/신용카드

            - 휴대폰결제

            - 실시간 계좌이체

            - 무통장입금

            - 네이버페이/ 카카오페이

            2. 포인트 환불의 경우 결제한 수단으로 환불됩니다. 구매 후 7일 이내 일부 사용 후 잔여 포인트에 대한 구매 취소는 고객센터를 통해 가능하며, 포인트 구매 시 지급된 보너스 포인트를 사용한 경우에는 해당 분량을 제외하고 환불됩니다.

            포인트 구매 시 지급되는 보너스 포인트와 이벤트로 받은 무료 포인트는 구매 취소 및 환불 대상이 아닙니다.

            3. 휴대폰 결제의 경우 당월은 취소만 가능, 익월 이후 청구요금 수납 확인 후 결제자 본인 계좌 환불 가능합니다.

            4. 신용카드결제 및 휴대폰결제는 신용카드사 및 이동통신사의 환불기준에 의거하여 시일이 소요될 수 있습니다.

            제17조 (광고의 게재 및 발신)

            1. 회사가 회원에게 서비스를 제공할 수 있는 투자기반의 일부는 광고게재를 통한 수익에서 나옵니다. 회사는 회원이 등록한 게시물이나 그 내용을 활용한 광고 게재 및 기타서비스를 이용하면서 노출되는 광고를 게재할 수 있습니다.

            2. 회사는 회원이 광고성 정보수신에 동의할 경우, 이메일, 푸시알림, 1:1 대화, 문자메시지 등 전자적 매체를 이용하여 광고성 정보를 발신할 수 있습니다.

            제18조 (이용계약 해지)

            1. 회원은 언제든지 “회원탈퇴하기”를 통해 이용계약 해지신청을 할 수 있으며, 회사는 관련법등이 정하는바에 따라 이를 즉시 처리하여야 합니다.

            2. 회원이 이용계약을 해지할 경우, 관련법 및 통합 개인 정보처리방침에 따라 모든 개인정보가 처리됩니다.

            3. 회원이 이용계약을 해지 하더라도, 서비스 이용 시 작성하거나 만들어진 모든 게시물은 삭제되지 않습니다.

            4. 회원이 이용계약을 해지한 뒤 새로 가입한 경우, 해지한 계정의 게시물권한 등 모든 권리는 이양 되지 않습니다.

            제19조 (개인정보보호)

            1. 회사는 회원의 개인정보를 보호하기 위하여 개인정보 보호법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관계 법령에서 정하는 바를 준수합니다.

            2. 회사는 회원의 개인정보를 보호하기 위하여 개인정보 처리방침을 제정, 서비스 초기화면에 게시합니다. 다만, 개인정보 처리방침의 구체적인 내용은 연결화면을 통하여 볼 수 있습니다.

            3. 회사는 이용계약을 위하여 회원이 제공한 정보를 회사의 서비스 운영을 위한 목적 이외의 용도로 사용하거나 회원의 동의 없이 제3자에게 제공하지 않습니다. 단, 다음 각 호의 경우에는 예외로 합니다.

            - 법령에 근거하여 회원정보의 이용과 제3자에 대한 정보제공이 허용되는 경우

            - 물품 배송업무 등 거래 이행에 필요한 최소한의 회원정보(성명, 주소, 연락처 등)를 배송업체에 알려주는 경우

            - 기타 회사의 약관 및 정책에 따라 회원의 동의를 구한 경우

            - 회사는 개인정보 처리방침에 따라 회원의 개인정보를 최대한 보호하기 위하여 노력합니다.

            제20조 (면책 조항)

            1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 회원에게 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.

            2. 회사는 회원의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.

            3. 회사는 회원이 게재한 정보, 자료, 사실의 신뢰도, 정확성 등 내용에 관해서는 책임을 지지 않습니다.

            4. 회사는 회원간 또는 회원과 제3자 상호간에 서비스를 매개로 하여 거래 등을 한 경우에는 책임을 지지 않습니다.

            5. 회원이 발송한 메일 내용에 대한 법적인 책임은 회원에게 있습니다.

            6. 단, 회사는 회원 간 또는 회원과 제3자 간 분쟁이 발발했음을 양 당사자 중 한 명 이상으로부터 통보를 받을 경우 전자상거래법에 의거 원만한 분쟁해결 지원을 위해 거래 및 양자의 계정에 개입 혹은 기타 분쟁해결에 필요하다고 판단되는 모든 조치(거래금액 동결, 계정정지 등)를 취할 수 있으며, 이 조치는 분쟁이 해결되는 시점까지 지속될 수 있습니다. 단, 회사에서 회원 간 또는 회원과 제3자 간 자체적으로 분쟁 해결이 어렵다고 판단되는 경우 회사는 하기의 외부기관들에 분쟁건을 이관할 수 있으며, 이관된 시점 이후부터는 분쟁조정권고 등 이관된 기관의 의견을 신뢰하며 이를 기준으로 분쟁관련 업무를 처리합니다.

            - 대한상사중재원 ( http://www.kcab.or.kr/intro.jsp )

            - 한국소비자원 ( http://www.kca.go.kr/ )

            - 한국공정거래조정원 ( http://www.kofair.or.kr/goMain.do )

            - 정보통신산업진흥원 전자문서·전자거래분쟁조정위원회 ( http://www.ecmc.or.kr )

            - 한국콘텐츠진흥원 콘텐츠분쟁조정위원회 (https://www.kcdrc.kr/)

            제21조 (분쟁 해결 및 통지)

            1. 회사는 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위해서 피해보상처리 기구를 설치, 운영합니다.

            2. 회사는 이용자로부터 제출되는 불만사항 및 의견을 지체 없이 처리하고자 최선을 다하여야 합니다. 다만 신속한 처리가 곤란한 경우에는 이용자에게 그 사유와 처리 일정을 통보합니다.

            3. 회사와 회원 간에 발생한 전자상거래 분쟁과 관련하여 회원의 피해구제 신청이 있는 경우에는 공정거래위원회 또는 시도지사가 의뢰하는 분쟁조정기관의 조정에 따를 수 있습니다.

            제22조 (계약의 해제, 해지 손해배상 등 각종 책임)

            1. 회원 또는 회사 중 일방이 본 약관에 명시된 사항을 위반하는 경우 상대방은 상당한 기간을 정하여 상대방에게 위반사항을 시정할 것을 요구할 수 있으며, 시정 요구에도 불구하고 위반사항을 시정하지 아니하면 서면(전자문서, 이메일을 포함하며, 이하 같다)으로 계약을 해지할 수 있습니다.

            2. 회사와 회원은 상대방이 주요 자산에 대한 압류 등 강제집행, 거래정지 또는 회생 및 파산신청 등으로 인해 정상적으로 계약 이행을 할 수 없을 경우 계약을 즉시 해지할 수 있습니다.

            3. 일방의 귀책사유로 본 계약을 위반하여 발생한 손해에 대하여 상대방은 배상 책임을 부담합니다.

            4. 회원이 본 약관 등의 위반 행위와 관련하여 각종 관련 법규(행정, 형사, 공정거래 관련 법률 등)를 위반함이 밝혀진 경우, 본 조에 따른 손해배상 외의 형사절차(고발, 고소 등)를 진행할 수 있으며, 회원은 위반 행위로 인한 제3자의 손해(예: 참가자의 개인정보 유출, 명예훼손 등)에 대해서도 책임을 집니다.

            제23조 (준거법 및 관할법원)

            1. 이 약관의 해석 및 회사와 회원간의 분쟁에 대하여는 대한민국의 법령을 적용합니다.

            2. 서비스 이용 중 발생한 회원과 회사간의 소송은 민사소송법에 의한 관할법원에 제소합니다.
            $10 상당의 새해 선물이 도착했어요
            라이너 프리미엄과 함께
            생산성 넘치는 2022년을 시작하세요

            닫기
            선물 열어보기

            """
        case .privacy_collect:
            return """
            애플맹고 ㈜는 「개인정보보호법」에 의거하여, 아래와 같은 내용으로 개인정보를 수집하고 있습니다.
            귀하께서는 아래 내용을 자세히 읽어 보시고, 모든 내용을 이해하신 후에 동의 여부를 결정해 주시기 바랍니다.

            Ⅰ. 개인정보의 수집 및 이용 동의서
             - 이용자가 제공한 모든 정보는 다음의 목적을 위해 활용하며, 하기 목적 이외의 용도로는 사용되지 않습니다.
            ① 개인정보 수집 항목 및 수집·이용 목적
             가) 수집 항목 (필수항목)
            - 이름 , 생년 , 성별 , 로그인 ID ,비밀 번호, 휴대 전화 번호, 자택 주소, 이메일, 직군 , 회사명 , 부서, 직책, 회사 전화 번호, 서비스 이용 기록 ,접속 로그 , 접속 IP 정보 , 결제기록 등 SNS 로그인을 통해 확보한 정보 및 추가 정보에 기재된 정보 또는 회원이 제공한 정보
             나) 수집 및 이용 목적
            -회원의 식별·확인, 회원가입 의사 확인, 중복가입 여부 확인, 계약의 체결·이행·관리, 결제 및 환불, 활동 지역 통계 분석, 운동 주기 분석, 서비스 개선, 민원 기타 문의 사항 처리, 부정이용에 대한 조사 및 대응, 고지사항 전달, 청구서 등의 발송, 법령상 의무 이행, 사은/판촉행사 등 각종 이벤트, 개인 맞춤형 서비스 제공, 새로운 상품 기타 행사 관련 정보 안내 및 마케팅 활동, 이메일 초대권 활용 내역 조회, 회사 및 제휴사 상품/서비스 안내 및 권유의 목적
            -회원 관리
            - 회원제 서비스 이용에 따른 본인 확인 , 개인 식별 , 연령 확인 , 만 14세 미만 아동 개인 정보 수집 시 법정 대리인 동의여부 확인 , 고지사항 전달 ο 마케팅 및 광고에 활용
            - 접속 빈도 파악 또는 회원의 서비스 이용에 대한 통계
             ② 개인정보 보유 및 이용기간
             - 수집·이용 동의일로부터 개인정보의 수집·이용목적을 달성할 때까지
             ③ 동의거부관리
             - 귀하께서는 본 안내에 따른 개인정보 수집, 이용에 대하여 동의를 거부하실 권리가 있습니다. 다만, 귀하가 개인정보의 수집/이용에 동의를 거부하시는 경우 러너비 서비스 이용에 있어 불이익이 발생할 수
            있음을 알려드립니다.
            $10 상당의 새해 선물이 도착했어요
            라이너 프리미엄과 함께
            생산성 넘치는 2022년을 시작하세요

            닫기
            선물 열어보기
            """
        case .privacy_deal:
            return """
            <러너비>('https://www.runnerbe2.shop/')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.

            개인정보처리방침

            최종 변경일 : 2022. 2. 27

            러너비(이하 '회사')는 고객님의 개인정보를 중요시하며, "정보 통신망 이용 촉진 및 정보 보호"에 관한 법률을 준수하고 있습니다.
            회사는 개인 정보 처리 방침을 통하여 고객님께서 제공하시는 개인 정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인 정보 보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.  회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지) 및 모바일 앱을 통하여 공지할 것입니다.

            ■ 수집하는 개인 정보 항목
            회사는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인 정보를 수집하고 있습니다.
            ο 수집항목 : 이름 , 생년 , 성별 , 로그인 ID ,비밀 번호, 휴대 전화 번호, 자택 주소, 이메일, 직군 , 회사명 , 부서, 직책, 회사 전화 번호, 서비스 이용 기록 ,접속 로그 , 접속 IP 정보 , 결제기록
            ο 개인정보 수집방법 : 홈페이지(회원가입), 서면 양식

            ■ 개인 정보의 수집 및 이용목적
            회사는 SNS 로그인을 통한 사용자의 UUID, 홈페이지, 앱, 고객센터, 게시판, 이벤트 참여, 제휴사로부터의 전달 등을 통해 개인정보를 수집합니다.
            회사는 수집한 개인 정보를 다음의 목적을 위해 활용합니다.
            ο 회원의 식별·확인, 회원가입 의사 확인, 중복가입 여부 확인, 계약의 체결·이행·관리, 결제 및 환불, 활동 지역 통계 분석, 운동 주기 분석, 서비스 개선, 민원 기타 문의 사항 처리, 부정이용에 대한 조사 및 대응, 고지사항 전달, 청구서 등의 발송, 법령상 의무 이행, 사은/판촉행사 등 각종 이벤트, 개인 맞춤형 서비스 제공, 새로운 상품 기타 행사 관련 정보 안내 및 마케팅 활동, 이메일 초대권 활용 내역 조회, 회사 및 제휴사 상품/서비스 안내 및 권유의 목적
            ο 회원 관리
            회원제 서비스 이용에 따른 본인 확인 , 개인 식별 , 연령 확인 , 만 14세 미만 아동 개인 정보 수집 시 법정 대리인 동의여부 확인 , 고지사항 전달 ο 마케팅 및 광고에 활용
            접속 빈도 파악 또는 회원의 서비스 이용에 대한 통계

            ■ 개인 정보의 보유 및 이용 기간
            회사는 개인정보 수집 및 이용목적이 달성된 후에는 예외 없이 해당 정보를 지체 없이 파기합니다.

            ■ 개인 정보의 파기 절차 및 방법
            회사는 원칙적으로 개인 정보 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.
            ο 파기 절차
            회원님이 회원 가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기되어집니다.
            별도 DB로 옮겨진 개인 정보는 법률에 의한 경우가 아니고서는 보유되어지는 이외의 다른 목적으로 이용되지 않습니다.
            ο 파기 방법
            - 전자적 파일 형태로 저장된 개인 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.

            ■ 개인정보의 제3자 제공
            회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 단, 개인정보보호법 제18조(개인정보의 이용•제공제한) 및 제 27조(영업양도 등에 따른 개인정보의 이전 제한)에 근거하여 다음의 경우에는 개인정보를 처리할 수 있습니다.
            - 이용자들이 사전에 동의한 경우
            - 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우
            - 서비스의 제공에 관한 계약의 이행을 위하여 필요한 개인정보로서 경제적/기술적인 사유로 통상의 동의를 받는 것이 현저히 곤란한 경우
            - 영업 양도 등에 따라 회사의 영업이 양도된 경우 (단, 개인정보보호법 제 27조에 따라 회사는 회원들에게 사전 공지를 해야 하며, 동의하지 않는 회원에 대해 그 방법과 절차를 필히 안내함)

            ■ 수집한 개인정보의 위탁
            회사는 고객님의 동의없이 고객님의 정보를 외부 업체에 위탁하지 않습니다. 향후 그러한 필요가 생길 경우, 위탁 대상자와 위탁 업무 내용에 대해 고객님에게 통지하고 필요한 경우 사전 동의를 받도록 하겠습니다.

            ■ 이용자 및 법정 대리인의 권리와 그 행사방법
            이용자 및 법정 대리인은 언제든지 등록되어 있는 자신 혹은 당해 만 14세 미만 아동의 개인정보를 조회하거나 수정할 수 있으며 가입해지를 요청할 수도 있습니 다.
            이용자 혹은 만 14세 미만 아동의 개인정보 조회, 수정을 위해서는 ‘개인정보변경’(또는 ‘회원 정보수정’ 등)을 가입해지(동의철회)를 위해서는 “회원탈퇴”를 클릭 하여 본인 확인 절차를 거치신 후 직접 열람, 정정 또는 탈퇴가 가능합니다. 혹은 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체없이 조 치하겠습니다.
            귀하가 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까 지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자 에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체없이 통지하여 정정이 이루어지도록 하겠습니다.
            러너비는 이용자 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 “러너비가 수집하는 개인정보의 보유 및 이용기간”에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.

            ■ 개인정보에 관한 민원서비스
            회사는 고객의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 관련 부서 및 개인정보관리책임자를 지정하고 있습니다.

            개인정보관리책임자
            성명 : 김은서
            이메일 : 0728kes@naver.com

            귀하께서는 회사의 서비스를 이용하시며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당부서로 신고하실 수 있습니다. 회사는 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.
            기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.
            1.대검찰청 사이버수사과 (cybercid.spo.go.kr)
            2.경찰청 사이버테러대응센터 (www.ctrc.go.kr/02-392-0330)
            $10 상당의 새해 선물이 도착했어요
            라이너 프리미엄과 함께
            생산성 넘치는 2022년을 시작하세요

            닫기
            선물 열어보기
            """
        case .location:
            return """

            위치기반서비스 이용약관(안)



            제1장 총   칙

            제 1 조 (목적) 본 약관은 회원(러너비 서비스 약관에 동의한 자를 말합니다. 이하 “회원”이라고 합니다.)이 주식회사 애플맹고(이하 “회사”라고 합니다.)가 제공하는 러너비 서비스(이하 “서비스”라고 합니다)를 이용함에 있어 회사와 회원의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.

            제 2 조 (이용약관의 효력 및 변경)
              ①본 약관은 서비스를 신청한 고객 또는 개인위치정보주체가 본 약관에 동의하고 회사가 정한 소정의 절차에 따라 서비스의 이용자로 등록함으로써 효력이 발생합니다.
              ②회원이 온라인에서 본 약관의 "동의하기" 버튼을 클릭하였을 경우 본 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 그 적용에 동의한 것으로 봅니다.
              ③회사는 위치정보의 보호 및 이용 등에 관한 법률, 콘텐츠산업 진흥법, 전자상거래 등에서의 소비자보호에 관한 법률, 소비자기본법 약관의 규제에 관한 법률 등 관련법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.
              ④회사가 약관을 개정할 경우에는 기존약관과 개정약관 및 개정약관의 적용일자와 개정사유를 명시하여 현행약관과 함께 그 적용일자 10일 전부터 적용일 이후 상당한 기간 동안 공지만을 하고, 개정 내용이 회원에게 불리한 경우에는 그 적용일자 30일 전부터 적용일 이후 상당한 기간 동안 각각 이를 서비스 홈페이지에 게시하거나 회원에게 전자적 형태(전자우편, SMS 등)로 약관 개정 사실을 발송하여 고지합니다.
              ⑤회사가 전항에 따라 회원에게 통지하면서 공지 또는 공지∙고지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 이용약관에 승인한 것으로 봅니다. 회원이 개정약관에 동의하지 않을 경우 회원은 이용계약을 해지할 수 있습니다.

            제 3 조 (관계법령의 적용)  본 약관은 신의성실의 원칙에 따라 공정하게 적용하며, 본 약관에 명시되지 아니한 사항에 대하여는 관계법령 또는 상관례에 따릅니다.

            제 4 조 (서비스의 내용)  회사가 제공하는 서비스는 아래와 같습니다.

            서비스 명
            서비스 내용
            러너비
            이용자 위치를 기준으로 주변의 가까운 운동 모임 제공



            제 5 조 (서비스 이용요금)
              ①회사가 제공하는 서비스는 기본적으로 무료입니다. 단, 별도의 유료 서비스의 경우 해당 서비스에 명시된 요금을 지불하여야 사용 가능합니다.
              ②회사는 유료 서비스 이용요금을 회사와 계약한 전자지불업체에서 정한 방법에 의하거나 회사가 정한 청구서에 합산하여 청구할 수 있습니다.
              ③유료서비스 이용을 통하여 결제된 대금에 대한 취소 및 환불은 회사의 결제 이용약관 등 관계법에 따릅니다.
              ④회원의 개인정보도용 및 결제사기로 인한 환불요청 또는 결제자의 개인정보 요구는 법률이 정한 경우 외에는 거절될 수 있습니다.
              ⑤무선 서비스 이용 시 발생하는 데이터 통신료는 별도이며 가입한 각 이동통신사의 정책에 따릅니다.
              ⑥MMS 등으로 게시물을 등록할 경우 발생하는 요금은 이동통신사의 정책에 따릅니다.

            제 6 조 (서비스내용변경 통지 등)
              ①회사가 서비스 내용을 변경하거나 종료하는 경우 회사는 회원의 등록된 전자우편 주소로 이메일을 통하여 서비스 내용의 변경 사항 또는 종료를 통지할 수 있습니다.
              ②①항의 경우 불특정 다수인을 상대로 통지를 함에 있어서는 웹사이트 등 기타 회사의 공지사항을 통하여 회원들에게 통지할 수 있습니다.

            제 7 조 (서비스이용의 제한 및 중지)
              ①회사는 아래 각 호의 1에 해당하는 사유가 발생한 경우에는 회원의 서비스 이용을 제한하거나 중지시킬 수 있습니다.
                1. 회원이 회사 서비스의 운영을 고의 또는 중과실로 방해하는 경우
                2. 서비스용 설비 점검, 보수 또는 공사로 인하여 부득이한 경우
                3. 전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우
                4. 국가비상사태, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 서비스 이용에 지장이 있는 때
                5. 기타 중대한 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우
              ②회사는 전항의 규정에 의하여 서비스의 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간 등을 회원에게 알려야 합니다.

            제 8 조 (개인위치정보의 이용 또는 제공)
              ①회사는 개인위치정보를 이용하여 서비스를 제공하고자 하는 경우에는 미리 이용약관에 명시한 후 개인위치정보주체의 동의를 얻어야 합니다.
              ②회원 및 법정대리인의 권리와 그 행사방법은 제소 당시의 이용자의 주소에 의하며, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.
              ③회사는 타사업자 또는 이용 고객과의 요금정산 및 민원처리를 위해 위치정보 이용·제공․사실 확인자료를 자동 기록·보존하며, 해당 자료는 6개월간 보관합니다.
              ④회사는 개인위치정보를 회원이 지정하는 제3자에게 제공하는 경우에는 개인위치정보를 수집한 당해 통신 단말장치로 매회 회원에게 제공받는 자, 제공일시 및 제공목적을 즉시 통보합니다. 단, 아래 각 호의 1에 해당하는 경우에는 회원이 미리 특정하여 지정한 통신 단말장치 또는 전자우편주소로 통보합니다.
                1. 개인위치정보를 수집한 당해 통신단말장치가 문자, 음성 또는 영상의 수신기능을 갖추지 아니한 경우
                2. 회원이 온라인 게시 등의 방법으로 통보할 것을 미리 요청한 경우

            제 9 조 (개인위치정보주체의 권리)
              ①회원은 회사에 대하여 언제든지 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제3자 제공에 대한 동의의 전부 또는 일부를 철회할 수 있습니다. 이 경우 회사는 수집한 개인위치정보 및 위치정보 이용, 제공사실 확인자료를 파기합니다.
              ②회원은 회사에 대하여 언제든지 개인위치정보의 수집, 이용 또는 제공의 일시적인 중지를 요구할 수 있으며, 회사는 이를 거절할 수 없고 이를 위한 기술적 수단을 갖추고 있습니다.
              ③회원은 회사에 대하여 아래 각 호의 자료에 대한 열람 또는 고지를 요구할 수 있고, 당해 자료에 오류가 있는 경우에는 그 정정을 요구할 수 있습니다. 이 경우 회사는 정당한 사유 없이 회원의 요구를 거절할 수 없습니다.
                1. 본인에 대한 위치정보 수집, 이용, 제공사실 확인자료
                2. 본인의 개인위치정보가 위치정보의 보호 및 이용 등에 관한 법률 또는 다른 법률 규정에 의하여 제3자에게 제공된 이유 및 내용
              ④회원은 제1항 내지 제3항의 권리행사를 위해 회사의 소정의 절차를 통해 요구할 수 있습니다.

            제 10 조 (법정대리인의 권리)
              ①회사는 14세 미만의 회원에 대해서는 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제3자 제공에 대한 동의를 당해 회원과 당해 회원의 법정대리인으로부터 동의를 받아야 합니다. 이 경우 법정대리인은 제9조에 의한 회원의 권리를 모두 가집니다.
              ②회사는 14세 미만의 아동의 개인위치정보 또는 위치정보 이용․제공사실 확인자료를 이용약관에 명시 또는 고지한 범위를 넘어 이용하거나 제3자에게 제공하고자 하는 경우에는 14세미만의 아동과 그 법정대리인의 동의를 받아야 합니다. 단, 아래의 경우는 제외합니다.
                1. 위치정보 및 위치기반서비스 제공에 따른 요금정산을 위하여 위치정보 이용, 제공사실 확인자료가 필요한 경우
                2. 통계작성, 학술연구 또는 시장조사를 위하여 특정 개인을 알아볼 수 없는 형태로 가공하여 제공하는 경우

            제 11 조 (8세 이하의 아동 등의 보호의무자의 권리)
              ①회사는 아래의 경우에 해당하는 자(이하 “8세 이하의 아동”등이라 한다)의 보호의무자가 8세 이하의 아동 등의 생명 또는 신체보호를 위하여 개인위치정보의 이용 또는 제공에 동의하는 경우에는 본인의 동의가 있는 것으로 봅니다.
                1. 8세 이하의 아동
                2. 금치산자
                3. 장애인복지법제2조제2항제2호의 규정에 의한 정신적 장애를 가진 자로서장애인고용촉진및직업재활법 제2조제2호의 규정에 의한 중증장애인에 해당하는 자(장애인복지법 제29조의 규정에 의하여 장애인등록을 한 자에 한한다)
             ②8세 이하의 아동 등의 생명 또는 신체의 보호를 위하여 개인위치정보의 이용 또는 제공에 동의를 하고자 하는 보호의무자는 서면동의서에 보호의무자임을 증명하는 서면을 첨부하여 회사에 제출하여야 합니다.
             ③보호의무자는 8세 이하의 아동 등의 개인위치정보 이용 또는 제공에 동의하는 경우 개인위치정보주체 권리의 전부를 행사할 수 있습니다.

            제 12 조 (위치정보관리책임자의 지정)
              ①회사는 위치정보를 적절히 관리․보호하고 개인위치정보주체의 불만을 원활히 처리할 수 있도록 실질적인 책임을 질 수 있는 지위에 있는 자를 위치정보관리책임자로 지정해 운영합니다.
              ②위치정보관리책임자는 위치기반서비스를 제공하는 부서의 부서장으로서 구체적인 사항은 본 약관의 부칙에 따릅니다.

            제 13 조 (손해배상)
              ①회사가 위치정보의 보호 및 이용 등에 관한 법률 제15조 내지 제26조의 규정을 위반한 행위로 회원에게 손해가 발생한 경우 회원은 회사에 대하여 손해배상 청구를 할 수 있습니다. 이 경우 회사는 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.
              ②회원이 본 약관의 규정을 위반하여 회사에 손해가 발생한 경우 회사는 회원에 대하여 손해배상을 청구할 수 있습니다. 이 경우 회원은 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.

            제 14 조 (면책)
              ①회사는 다음 각 호의 경우로 서비스를 제공할 수 없는 경우 이로 인하여 회원에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.
                1. 천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우
                2. 서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제3자의 고의적인 서비스 방해가 있는 경우
                3. 회원의 귀책사유로 서비스 이용에 장애가 있는 경우
                4. 제1호 내지 제3호를 제외한 기타 회사의 고의∙과실이 없는 사유로 인한 경우

              ②회사는 서비스 및 서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 회원의 손해에 대하여는 책임을 부담하지 아니합니다.

            제 15 조 (규정의 준용)
              ①본 약관은 대한민국법령에 의하여 규정되고 이행됩니다.
              ②본 약관에 규정되지 않은 사항에 대해서는 관련법령 및 상관습에 의합니다.

            제 16 조 (분쟁의 조정 및 기타)
              ①회사는 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 위치정보의 보호 및 이용 등에 관한 법률 제28조의 규정에 의한 방송통신위원회에 재정을 신청할 수 있습니다.
              ②회사 또는 고객은 위치정보와 관련된 분쟁에 대해 당사자간 협의가 이루어지지 아니하거나 협의를 할 수 없는 경우에는 개인정보보호법 제43조의 규정에 의한 개인정보분쟁조정위원회에 조정을 신청할 수 있습니다.

            제 17 조 (회사의 연락처) 회사의 상호 및 주소 등은 다음과 같습니다.
              1. 상    호 : 애플맹고
              2. 대 표 자 : 김은서
              3. 주    소 : 공덕 프론트원 3층

            부  칙

            제1조 (시행일) 이 약관은 2022년  03월 01일부터 시행한다.
            제2조 위치정보관리책임자는 2022년 03월을 기준으로 다음과 같이 지정합니다.
              1. 소  속 : 기획팀 / 김은서
              2. 연락처 : 0728kes@naver.com
            $10 상당의 새해 선물이 도착했어요
            라이너 프리미엄과 함께
            생산성 넘치는 2022년을 시작하세요

            닫기
            선물 열어보기
            """
        }
    }
}