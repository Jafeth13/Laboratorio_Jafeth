using Domain.Entidades.User;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Interfaces.GetUserByEmail
{
    public interface IGetUserByEmailDAL
    {
        Task<UserETL> GetUserByEmail(string email);

    }
}
