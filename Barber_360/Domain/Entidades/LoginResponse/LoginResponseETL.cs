using Domain.Entidades.UserInfo;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entidades.LoginResponse
{
    public class LoginResponseETL
    {
        public bool Success { get; set; }
        public string Token { get; set; }
        public string Message { get; set; }
        public UserInfoETL User { get; set; }
    }
}
